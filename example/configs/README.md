# Flutter app customizer script
Shell script used to update app name, package name and app icon

# Installation

## 1. Git Submodule

```bash
git submodule add https://github.com/chungxon/flutter_app_customizer configs
```

## 2. Update file manually
- Create a `configs` folder on your root project folder

    ```bash
    mkdir configs
    ```

- Here is the result

    ```
    my-app/ -> Root folder
    ├─ android/
    ├─ configs/ -> This is the custom folder
    ├─ ios/
    ├─ lib/
    ```

- Copy all files and folders of this project to `configs` folder.

# Usage

## 1. Setup your app configs
- Open the `configs.props` file
    - Update your app name
    - Update your iOS bundle ID
    - update your Android package name

## 2. Update your app icon
- Add your icon in `assets/icons/app_icon.png` or `configs/overrides/assets/icons/app_icon.png`
- Or you can update the `image_path` in the `flutter_launcher_icons.yaml` file

## 3. Run script
Run the command

```bash
sh configs/app_customizer.sh
```

# Dependencies
This repo depends on another repo https://github.com/chungxon/load_properties