# Troubleshooting

## Build Errors

### QEMU Emulator Errors

If you encounter errors related to QEMU emulator when building for ARM64 on a non-ARM64 machine:

1. **Ensure QEMU is properly set up:**
   ```bash
   docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
   ```

2. **Use the default buildx builder:**
   The default builder already supports ARM64. The build script uses it automatically.
   If you need to manually switch:
   ```bash
   docker buildx use default
   ```
   
   If you have a problematic custom builder, remove it:
   ```bash
   docker buildx rm multiarch  # or whatever name it has
   ```

3. **Try building with reduced parallelism:**
   If the build still fails, you can modify the Dockerfile to use fewer parallel jobs:
   - Change `make -j2` to `make -j1` (single-threaded build)
   - This will be slower but more reliable in emulated environments

4. **Build on native ARM64 hardware:**
   For best results, build on native ARM64 hardware (e.g., Apple Silicon Mac, ARM64 Linux server, or GitHub Actions with ARM64 runners)

### Build Timeout

If the build times out:
- Increase Docker build timeout settings
- Use GitHub Actions which has longer timeout limits
- Consider building on more powerful hardware

### Missing Dependencies

If you get errors about missing packages:
- Check Alpine package repository for ARM64 support
- Some packages might need to be built from source
- Verify that all dependencies are available for ARM64 architecture

## GitHub Actions Build

The GitHub Actions workflow automatically handles:
- Setting up buildx
- Configuring QEMU emulation
- Building for ARM64 platform
- Publishing to GitHub Container Registry

If builds fail in GitHub Actions, check:
1. Workflow logs for specific error messages
2. Ensure the workflow has proper permissions
3. Verify that the Dockerfile syntax is correct

