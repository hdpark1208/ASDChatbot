import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
import urllib.request

from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences

df = pd.read_table('./dataset/dataset.txt',header=None, error_bad_lines=False)

df[['sentence','label']] = pd.DataFrame(df[0].str.split('|', 1).tolist())

df = df.drop([0],axis=1)

train_data, test_data = train_test_split(df, test_size=0.3, random_state=777)
# print(len(train_data),len(test_data))

train_data['sentence'] = train_data['sentence'].str.replace("[^ㄱ-ㅎㅏ-ㅣ가-힣 ]","")
train_data['sentence'].replace('', np.nan, inplace=True)
# print(train_data.isnull().sum())

train_data.dropna(inplace=True)
# print(train_data.isnull().sum())

test_data['sentence'] = test_data['sentence'].str.replace("[^ㄱ-ㅎㅏ-ㅣ가-힣 ]","")
test_data['sentence'].replace('', np.nan, inplace=True)
# print(test_data.isnull().sum())

test_data.dropna(inplace=True)
# print(test_data.isnull().sum())

"""###형태소 분석"""

from konlpy.tag import Mecab
mecab = Mecab(dicpath=r"C:\MeCab\mecab-ko-dic")

stopwords = ['도', '는', '다', '의', '가', '이', '은', '한', '에', '하', '고', '을', '를', '인', '듯', '과', '와', '네', '들', '듯', '지', '임', '게','.','ㅋㅋㅋ','ㅋㅋ','거','냐']

train_data['tokenized'] = train_data['sentence'].apply(mecab.morphs)
train_data['tokenized'] = train_data['tokenized'].apply(lambda x: [item for item in x if item not in stopwords])

test_data['tokenized'] = test_data['sentence'].apply(mecab.morphs)
test_data['tokenized'] = test_data['tokenized'].apply(lambda x: [item for item in x if item not in stopwords])

train_data['label'] = train_data['label'].astype('int')
test_data['label'] = test_data['label'].astype('int')

bad = np.hstack(train_data[train_data.label==1]['tokenized'].values)
normal = np.hstack(train_data[train_data.label==0]['tokenized'].values)

"""### 정수 인코딩"""

tokenizer = Tokenizer()
tokenizer.fit_on_texts(train_data['tokenized'])

threshold = 2
total_cnt = len(tokenizer.word_index) # 단어의 수
rare_cnt = 0 # 등장 빈도수가 threshold보다 작은 단어의 개수를 카운트
total_freq = 0 # 훈련 데이터의 전체 단어 빈도수 총 합
rare_freq = 0 # 등장 빈도수가 threshold보다 작은 단어의 등장 빈도수의 총 합

# 단어와 빈도수의 쌍(pair)을 key와 value로 받는다.
for key, value in tokenizer.word_counts.items():
    total_freq = total_freq + value

    # 단어의 등장 빈도수가 threshold보다 작으면
    if(value < threshold):
        rare_cnt = rare_cnt + 1
        rare_freq = rare_freq + value

# print('단어 집합(vocabulary)의 크기 :',total_cnt)
# print('등장 빈도가 %s번 이하인 희귀 단어의 수: %s'%(threshold - 1, rare_cnt))
# print("단어 집합에서 희귀 단어의 비율:", (rare_cnt / total_cnt)*100)
# print("전체 등장 빈도에서 희귀 단어 등장 빈도 비율:", (rare_freq / total_freq)*100)

vocab_size = total_cnt - rare_cnt + 1
# print('단어 집합의 크기 :',vocab_size)

tokenizer = Tokenizer(vocab_size) 
tokenizer.fit_on_texts(train_data['tokenized'])
X_train = tokenizer.texts_to_sequences(train_data['tokenized'])
X_test = tokenizer.texts_to_sequences(test_data['tokenized'])

y_train = np.array(train_data['label'])
y_test = np.array(test_data['label'])

drop_train = [index for index, sentence in enumerate(X_train) if len(sentence) < 1]

X_train = np.delete(X_train, drop_train, axis=0)
y_train = np.delete(y_train, drop_train, axis=0)
# print(len(X_train))
# print(len(y_train))

def below_threshold_len(max_len, nested_list):
  cnt = 0
  for s in nested_list:
    if(len(s) <= max_len):
        cnt = cnt + 1
  # print('전체 샘플 중 길이가 %s 이하인 샘플의 비율: %s'%(max_len, (cnt / len(nested_list))*100))

max_len = 50
below_threshold_len(max_len, X_train)

X_train = pad_sequences(X_train, maxlen = max_len)
X_test = pad_sequences(X_test, maxlen = max_len)

"""# LSTM"""

# 0. 사용할 패키지 불러오기
from tensorflow.python.keras.utils import np_utils
from tensorflow.python.keras.datasets import mnist
from tensorflow.python.keras.models import Sequential
from tensorflow.python.keras.layers import Dense, Activation

from numpy import argmax

from tensorflow.python.keras.models import load_model
loaded_model = load_model('./dataset/LSTM_Model.h5')

def sentiment_predict(new_sentence):
  new_sentence = mecab.morphs(new_sentence) # 토큰화
  new_sentence = [word for word in new_sentence if not word in stopwords] # 불용어 제거
  encoded = tokenizer.texts_to_sequences([new_sentence]) # 정수 인코딩
  pad_new = pad_sequences(encoded, maxlen = max_len) # 패딩
  score = float(loaded_model.predict(pad_new)) # 예측
  if(score > 0.5):
    return f"{score * 100}% 확률로 나쁜말 입니다"
  else:
    return f"{(1 - score) * 100}% 확률로 일상언어 입니다"
    # print("{:.2f}% 확률로 일상 언어 입니다.\n".format((1 - score) * 100))

# result = sentiment_predict('아 시발 짜증나노')



### 서버와 연결하면서 새롭게 추가한 부분 ###################################################################################################################
import sys
# import base64

# 외부에서 넘겨받은 인자로 함수를 실행하고, 넘어온 값을 result에 저장함
result = sentiment_predict(sys.argv[1])
# print(base64.b64encode(result.encode('utf-8')))
# if __name__ == "__main__":
#   sentiment_predict(sys.argv[1])

# 외부에서 값을 읽기 쉽도록 새로 txt파일을 생성했음
f = open("modelResult.txt", 'w')
# 저장된 값을 txt 에 저장하고
f.write(result)
# 열어둔 파일을 닫음
f.close()
