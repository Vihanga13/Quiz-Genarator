# Environment Setup Guide

## Quick Start

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the .env file with your actual values:**
   ```bash
   # Open .env in your text editor
   code .env  # if using VS Code
   ```

3. **Add your Groq API key:**
   - Get your API key from [Groq Console](https://console.groq.com/)
   - Replace `your_groq_api_key_here` with your actual API key in the `.env` file

4. **Install dependencies:**
   ```bash
   flutter pub get
   ```

5. **Run the app:**
   ```bash
   flutter run
   ```

## Important Security Notes

- **Never commit the `.env` file** to version control
- **Never share your `.env` file** with others
- **Use `.env.example`** to show what environment variables are needed
- **The `.env` file is already added to `.gitignore`**

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `GROQ_API_KEY` | Your Groq API key for AI quiz generation | Yes |

## Production Deployment

For production environments, set environment variables through your hosting platform rather than using a `.env` file.

## Troubleshooting

If you get "API key not configured" errors:
1. Make sure the `.env` file exists in the project root
2. Check that your API key is correctly set in the `.env` file
3. Restart the Flutter app after making changes to the `.env` file
