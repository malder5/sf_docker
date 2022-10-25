FROM python:3.9
WORKDIR /srv
# Устанавливаем зависимости
COPY requirements.txt /srv
RUN pip install -r requirements.txt
# Копируем приложение
COPY app/* /srv/app/
# Запускаем
CMD python app/web.py