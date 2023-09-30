# Convert audio file to video file with FFmpeg
```bash
ffmpeg -loop 1 -y -i photo-in.jpg -i audio-in.wav -shortest -acode flac -vcode libx264 - preset fast -vf scale=1280;-2 vid-out.mkv
```