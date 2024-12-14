import pyautogui
import time
import pyperclip

# 指定のアプリケーションを実行する。日本語名にも対応。
def open_application(application_name):
    pyautogui.press('winleft')
    time.sleep(0.5)
    pyperclip.copy(application_name)
    time.sleep(0.5)
    pyautogui.hotkey('ctrl', 'v')
    pyautogui.press('enter')


# 画面内に画像が認識されるまで待機。
def locate_image(image_path, confidence=0.7, timeout=10):
    start_time = time.time()
    while True:
        try:
            location = pyautogui.locateOnScreen(image_path, confidence=confidence)
            if location:
                return location
            if time.time() - start_time > timeout:
                    print(f"Timeout: {image_path} が見つかりませんでした。")
                    return None
        except pyautogui.ImageNotFoundException:
                if time.time() - start_time > timeout:
                    print(f"Timeout: {image_path} が見つかりませんでした。")
                    return None
                continue

# 画像が認識されるまで待機。認識後、対象を左クリック処理。
def click_image(image_path, confidence=0.7):
    while True:
        try:
            location = pyautogui.locateOnScreen(image_path, confidence=confidence)
            if location:
                pyautogui.click(location)
                return True
            print(f"{image_path} が認識できませんでした。")
            return False
        except pyautogui.ImageNotFoundException:
            continue

# 処理速度の計測
def speed_measurement(start, end, count):
    elapsed_time = end-start
    elapsed_time = round(elapsed_time, 2)
    print(f"{count}st TimeRecord：{elapsed_time} sec")

# ウィンドウを閉じる
def close_winodow():
    pyautogui.hotkey('alt', 'f4')


# メイン処理
def main(count):
    step1 = "step_images/step1.png"
    action1 = "action_images/action1.png"
    step2 = "step_images/step2.png"
    application_name = "google chrome"

    open_application(application_name)

    # step1
    if not locate_image(step1):
        return

    # action1
    if not click_image(action1):
        return

    # 計測開始
    start_time = time.time()

    # Step2
    if not locate_image(step2):
        return

    # 計測終了
    end_time = time.time() 
    speed_measurement(start_time, end_time, count)

    # ウィンドウを閉じる
    close_winodow()


if __name__ == "__main__":
    for i in range(1, 4):
        main(i)