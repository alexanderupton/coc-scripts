#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

void die(const char *msg) {
    fprintf(stderr, "%s\n", msg);
    exit(1);
}

int main(int argc, char *argv[]) {
    if (argc != 4) die("Usage: coc_rom_patcher <rom> <patch.ips> <output>");

    FILE *rom_in = fopen(argv[1], "rb");
    FILE *patch = fopen(argv[2], "rb");
    FILE *rom_out = fopen(argv[3], "wb+");

    if (!rom_in || !patch || !rom_out) die("Error opening files");

    // Copy input ROM to output file
    fseek(rom_in, 0, SEEK_END);
    long rom_size = ftell(rom_in);
    rewind(rom_in);
    char *rom_buf = malloc(rom_size);
    fread(rom_buf, 1, rom_size, rom_in);
    fwrite(rom_buf, 1, rom_size, rom_out);
    free(rom_buf);
    fclose(rom_in);

    char header[5];
    fread(header, 1, 5, patch);
    if (memcmp(header, "PATCH", 5) != 0) die("Invalid IPS header");

    while (1) {
        uint8_t off_bytes[3];
        if (fread(off_bytes, 1, 3, patch) != 3) break;

        if (memcmp(off_bytes, "EOF", 3) == 0) break;

        long offset = (off_bytes[0] << 16) | (off_bytes[1] << 8) | off_bytes[2];

        uint8_t size_bytes[2];
        fread(size_bytes, 1, 2, patch);
        int size = (size_bytes[0] << 8) | size_bytes[1];

        if (size == 0) {
            // RLE
            fread(size_bytes, 1, 2, patch);
            int rle_size = (size_bytes[0] << 8) | size_bytes[1];
            uint8_t val;
            fread(&val, 1, 1, patch);
            fseek(rom_out, offset, SEEK_SET);
            for (int i = 0; i < rle_size; i++) fwrite(&val, 1, 1, rom_out);
        } else {
            // Normal patch
            uint8_t *buf = malloc(size);
            fread(buf, 1, size, patch);
            fseek(rom_out, offset, SEEK_SET);
            fwrite(buf, 1, size, rom_out);
            free(buf);
        }
    }

    fclose(patch);
    fclose(rom_out);
    return 0;
}

