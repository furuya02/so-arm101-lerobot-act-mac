import cv2
import sys

CAMERA_INDEX = int(sys.argv[1]) if len(sys.argv) > 1 else 1

print(f'Opening camera at index {CAMERA_INDEX}...')
cap = cv2.VideoCapture(CAMERA_INDEX)

if not cap.isOpened():
    print(f'ERROR: Could not open camera at index {CAMERA_INDEX}.')
    print('Try a different index: uv run python preview_camera.py 0')
    sys.exit(1)

cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
cap.set(cv2.CAP_PROP_FPS, 30)

print(f'Camera opened. Press "q" to quit.')
print(f'Resolution: {int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))}x{int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))}')
print(f'FPS:        {int(cap.get(cv2.CAP_PROP_FPS))}')

while True:
    ret, frame = cap.read()
    if not ret:
        print('Failed to read frame.')
        break
    cv2.imshow(f'Camera index {CAMERA_INDEX} - press q to quit', frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
