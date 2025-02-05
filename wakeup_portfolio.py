from datetime import datetime
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

options = webdriver.ChromeOptions()
options.add_argument('--headless')  # Run in headless mode
options.add_argument('--disable-gpu')  # Disable GPU acceleration
options.add_argument('--no-sandbox')  # Bypass OS security model (needed for Docker)
options.add_argument('--disable-dev-shm-usage')  # Overcome limited resources in containers
options.add_argument('--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"')

# Initialize Chrome WebDriver
driver = webdriver.Chrome(options=options)

# Navigate to the URL
driver.get('https://protfolio-yosefi-kroytoro.streamlit.app/')

# open a log file
with open('logs.log', 'a') as log_file:
    try:
        # Wait for the button to load completely
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, '//button [contains(text(), "Yes, get this app back up!")]')))

        # Find and click the button to wake up the app
        auth_button = driver.find_element(By.XPATH, '//button [contains(text(), "Yes, get this app back up!")]')
        auth_button.click()

        log_file.write(f"{datetime.now()} - Button clicked successfully!\n")

    except Exception as e:
        log_file.write(f"{datetime.now()} - An error occurred: {e}\n")
    finally:
        driver.quit()