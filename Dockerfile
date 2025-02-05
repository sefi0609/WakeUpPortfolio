FROM python:3.10-alpine

# Install dependencies
RUN apk update
RUN apk add --no-cache \
    chromium \
    chromium-chromedriver \
    xvfb

RUN pip install --no-cache-dir selenium

COPY wakeup_portfolio.py /app/wakeup_portfolio.py
WORKDIR /app

CMD ["python", "wakeup_portfolio.py"]
