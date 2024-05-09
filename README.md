![Conecta.ai Logo](assets/images/main_logo.png)

![Flutter](https://img.shields.io/badge/Flutter-3.13.1-white.svg)
![Dart](https://img.shields.io/badge/Dart-3.1.0-white.svg)

# Chatbot AI

O app Chatbot AI é um aplicativo desenvolvido em Flutter que realiza pesquisas em manuais de veículos cadastrados na plataforma com o auxílio de inteligência artificial para auxiliar na resolução de problemas relacionados aos veículos.

## Instalação

1. Clone o repositório:
     ```
    git clone https://github.com/conect2ai/search_app.git
     ```

2. Mudei para a pasta:
     ```
    cd search_app
     ```
3. Cria o arquivo .env na pasta lib e insira a informação abaixo:
   ```
    API_AUTH_URL = "endereçoApi/user"
    API_SEARCH_URL = "endereçoApi"
    API_SEARCH_ENDPOINT_QUESTION = "/chat/answer_question"
    API_SEARCH_ENDPOINT_QUESTION_IMAGE = "/chat/answer_question_image"
    API_SEARCH_ENDPOINT_QUESTION_AUDIO = "/chat/answer_question_audio"
    API_CARS_ENDPOINT = "/chat/get_stored_cars"
    ```
4. Selecione o dispositivo que deseja utilizar para realizar a instalação do app
5. Execute o comando:
     ```
     flutter run lib/app/main.dart
     ```


### License
This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
