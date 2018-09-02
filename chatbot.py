from chatterbot import ChatBot

chatbot = ChatBot('fake_overbot', trainer='chatterbot.trainers.ChatterBotCorpusTrainer')

while True:
    str = input()
    print(chatbot.get_response(str))
