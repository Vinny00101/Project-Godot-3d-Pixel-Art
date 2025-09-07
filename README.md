# Project-Godot-3d-Pixel-Art

## Overview
This project showcases a **3D pixel art** (voxel art) implementation in the Godot Engine, blending the retro aesthetics of 2D pixel art with the depth of 3D modeling. Using cube-shaped **voxels**, it creates blocky, low-resolution 3D models reminiscent of early video games. Voxels form structures, characters, and environments in a grid-based system, offering a nostalgic yet modern style for games and digital art.

The project includes a **top-down camera script** for Godot, designed to navigate a 3D pixel art scene, and sample **voxel art assets** to demonstrate the visual style.

## Features
- **Top-Down Camera Script** (`TopDownCamera.gd`):
  - Moves in the XZ plane (WASD keys), preserving the initial height.
  - Rotates horizontally (mouse movement) for a top-down perspective.
  - Supports zoom (mouse wheel) for dynamic viewing.
  - Respects the initial position and rotation set in the Godot editor.
- **3D Pixel Art Assets**:
  - Sample voxel models (e.g., `.vox` files) created with tools like MagicaVoxel.
  - Low-res, blocky aesthetic inspired by retro games.
- **Godot Integration**:
  - Built for Godot 4 (compatible with Godot 3 with minor adjustments).
  - Easy-to-use script for controlling camera in 3D voxel-based scenes.

## Getting Started

### Prerequisites
- **Godot Engine**: Version 4.x (or 3.x with adjustments).
- **Git**: To clone the repository.
- **Optional**: Voxel editing tool like MagicaVoxel for modifying 3D pixel art assets.

### Installation
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Vinny00101/Project-Godot-3d-Pixel-Art.git
   cd Project-Godot-3d-Pixel-Art
   ```
2. **Open in Godot**:
   - Launch Godot Engine.
   - Click "Import" and select the project folder (`Project-Godot-3d-Pixel-Art`).
   - If no `project.godot` file exists, create a new Godot project and copy the `scripts/` and `assets/` folders into it.
3. **Set Up the Camera**:
   - Add a `Camera3D` node to your scene.
   - Attach the `scripts/TopDownCamera.gd` script to the `Camera3D` node.
   - Set the `Camera3D` as "Current" (enable the camera icon in the editor).
   - Adjust the initial position (e.g., `y = 10`) and rotation in the Godot editor.
4. **Add Voxel Assets**:
   - Import `.vox` files from the `assets/` folder into your Godot project.
   - Use Godot's `VoxelMesh` or a compatible importer to display 3D pixel art.
5. **Configure Input Map**:
   - Go to **Project > Project Settings > Input Map** in Godot.
   - Ensure the following actions are mapped:
     - `ui_up`: W or Up Arrow (move forward).
     - `ui_down`: S or Down Arrow (move backward).
     - `ui_left`: A or Left Arrow (move left).
     - `ui_right`: D or Right Arrow (move right).
     - `ui_cancel`: Esc (toggle mouse capture).
6. **Run the Scene**:
   - Press F5 to test.
   - Use WASD to move, mouse to rotate, mouse wheel to zoom, and Esc to toggle mouse capture.

## License
- **Code** (e.g., `TopDownCamera.gd`): Licensed under the [MIT License](LICENSE).
- **3D Pixel Art Assets** (e.g., `.vox` files): Licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](assets/LICENSE).

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch (`git switch -c feature/your-feature`).
3. Make your changes and commit (`git commit -m "Add your feature"`).
4. Push to your fork (`git push origin feature/your-feature`).
5. Open a Pull Request on GitHub.

Please ensure your changes align with the project's retro 3D pixel art aesthetic and Godot compatibility.

## Contact
For questions or feedback, open an issue on GitHub or contact [Vinny00101](https://github.com/Vinny00101).