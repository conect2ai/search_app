# Chatbot AI

O app Chatbot AI é um aplicativo desenvolvido em Flutter que realiza pesquisas em manuais de veículos cadastrados na plataforma com o auxílio de inteligência artificial para auxiliar na resolução de problemas relacionados aos veículos, assim como tirar dúvidas referentes a luzes no painel do carro.

## Iniciando

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




- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
