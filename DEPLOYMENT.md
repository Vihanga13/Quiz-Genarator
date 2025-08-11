# Deployment Guide

## Prerequisites
- Flutter SDK (3.0+)
- Git
- Groq API Key (from https://console.groq.com/)

## Setup Instructions

### 1. Clone Repository
```bash
git clone https://github.com/Vihanga13/Quiz-Genarator.git
cd Quiz-Genarator
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure API Keys
```bash
# Copy the template file
cp lib/config/api_config_local.dart.template lib/config/api_config_local.dart

# Edit the file and add your actual Groq API key
# Replace 'YOUR_GROQ_API_KEY_HERE' with your real API key
```

### 4. Run the Application
```bash
flutter run
```

## Security Notes

### API Key Management
- **Local Development**: API keys are stored in `lib/config/api_config_local.dart` (git-ignored)
- **Production**: Use environment variables or secure cloud storage
- **Never commit real API keys** to version control

### Files to Keep Secure
- `lib/config/api_config_local.dart` - Contains your actual API key
- `.env` files - Environment-specific configurations

## Production Deployment

### For Web
```bash
flutter build web
```

### For Android
```bash
flutter build apk --release
```

### For iOS
```bash
flutter build ios --release
```

## Environment Variables (Production)
Set these environment variables in your production environment:
- `GROQ_API_KEY`: Your Groq API key
- `GROQ_BASE_URL`: https://api.groq.com/openai/v1/chat/completions
- `GROQ_MODEL`: llama3-8b-8192

## Troubleshooting

### Common Issues
1. **API Key Not Configured**: Ensure you've copied and edited the local config file
2. **Network Issues**: Check your internet connection and API endpoint accessibility
3. **Build Errors**: Run `flutter clean && flutter pub get`

### Getting Help
- Check the [Issues](https://github.com/Vihanga13/Quiz-Genarator/issues) page
- Review the README.md for setup instructions
- Ensure all dependencies are properly installed
