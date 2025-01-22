from datetime import datetime
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.edge.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.microsoft import EdgeChromiumDriverManager

options = webdriver.EdgeOptions()
options.add_argument('--headless')  # Run in headless mode
options.add_argument('--disable-gpu')  # Disable GPU acceleration
options.add_argument('--user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"')

# Initialize Edge WebDriver
driver = webdriver.Edge(service=Service(EdgeChromiumDriverManager().install()), options=options)

# Navigate to the URL
driver.get('https://protfolio-yosefi-kroytoro.streamlit.app/')

# open file to write not append to save up space
log_file = open('logs.txt', 'w')

try:
    # Wait for the button to load completely
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH, '//button [contains(text(), "Yes, get this app back up!")]')))

    # Find and click the button to wake up the app
    auth_button = driver.find_element(By.XPATH, '//button [contains(text(), "Yes, get this app back up!")]')
    auth_button.click()

    log_file.write(f"{datetime.now()} - Button clicked successfully!")

except Exception as e:
    log_file.write(f"{datetime.now()} - An error occurred: {e}")
finally:
    driver.quit()
    log_file.close()