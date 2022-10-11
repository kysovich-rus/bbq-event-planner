# Шашлычки

Собери людей на шашлыки! Делитесь впечатлениями после вечеринки!

![image](https://user-images.githubusercontent.com/70809854/194773272-85feb78f-bc2b-4010-a30c-be734c2f8a38.png)

## В разработке использованы

`Rails 7.0.3`

`Ruby 3.0.1`

- `ActionMailer` + `Mailjet` - для реализации рассылки
- `ActiveStorage` + `Yandex Cloud Storage` - для хранения фотографий
- `Devise`, `Pundit` - для аутентификациии и авторизации
- `OmniAuth` - для аутентификации через Google, GitHub и VK
- `API Яндекс.Карт` - для отображения адреса события на карте
- `ActiveJob` + `Redis` + `Resque` - для реализации фоновых задач
- `Lightbox2` - для создания галереи с фотографиями события
- `Capistrano` - деплой

## Установка

1. Загрузить исходники проекта

2. Установить гемы проека и установить базу данных 
```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
```
3. Установить в переменных среды (.env или настройки Heroku):
```
MAILJET_SENDER=<адрес, с которого будет отправляться почта>
MAILJET_API_KEY=<ключ API клиента Mailjet>
MAILJET_SECRET_KEY=<секретный ключ API клиента Mailjet>

BBQ_7BS5_DATABASE_NAME=<название базы данных>
BBQ_7BS5_DATABASE_USERNAME=<имя пользователя СУБД>
BBQ_7BS5_DATABASE_PASSWORD=<пароль пользователя СУБД>

GOOGLE_OAUTH_CLIENT_ID=<ID клиента Google OAuth>
GOOGLE_OAUTH_CLIENT_SECRET=<пароль клиента Google OAuth>

GITHUB_OAUTH_CLIENT_ID=<ID клиента Github OAuth>
GITHUB_OAUTH_CLIENT_SECRET=<пароль клиента Github OAuth>

VK_OAUTH_CLIENT_ID=<ID клиента VK API OAuth>
VK_OAUTH_CLIENT_SECRET=<пароль клиента VK API OAuth>
```

4. Запустить локальный сервер 
```
bundle exec rails s
```
В production-окружении приложение работает на удаленном сервере.

