# todo-app

Flutter + Django App

## ⚙️ SETUP

You need to have Python and Flutter installed on your system

For help getting started with Python, view the
[online documentation](https://www.python.org/)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

1. Clone this repository
```bash
git clone https://github.com/HanifNahan/todo-app -b main
```

2. Install python package
```bash
cd todo_backend/
pip install -r requirements.txt
```

3. Run django server locally
```bash
python3 manage.py runserver
```

4. Install flutter packages
    - Open new terminal in root folder and run this command:
    ```bash
    cd app
    flutter pub get
    ```

5. Run app
    - copy development server url and put it in API_URL in .env file
    - run this command to run app
    ```bash
    flutter run
    ```
    choose your preferred platform