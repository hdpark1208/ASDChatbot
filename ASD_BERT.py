#!/usr/bin/env python
# coding: utf-8

# # Preprocessing

# In[1]:


import warnings
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
# import urllib.request

from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences


# In[2]:


warnings.filterwarnings('ignore')


# In[3]:


df = pd.read_table('./dataset.txt',header=None, error_bad_lines=False)


# In[ ]:





# In[4]:


df[['sentence','label']] = pd.DataFrame(df[0].str.split('|', 1).tolist())
df = df.drop([0],axis=1)
df


# In[5]:


print(df.isnull().values.any())


# In[6]:


train_data, test_data = train_test_split(df, test_size=0.3, random_state=777)
print(len(train_data),len(test_data))


# In[7]:


train_data['label'].value_counts().plot(kind = 'bar')


# In[8]:


print(train_data.groupby('label').size().reset_index(name = 'count'))

print(test_data.groupby('label').size().reset_index(name = 'count'))


# In[9]:


train_data['sentence'] = train_data['sentence'].str.replace("[^ㄱ-ㅎㅏ-ㅣ가-힣0-9 ]","")
train_data['sentence'].replace('', np.nan, inplace=True)
print(train_data.isnull().sum())


# In[10]:


train_data.dropna(inplace=True)
print(train_data.isnull().sum())


# In[11]:


test_data['sentence'] = test_data['sentence'].str.replace("[^ㄱ-ㅎㅏ-ㅣ가-힣0-9]","")
test_data['sentence'].replace('', np.nan, inplace=True)
print(test_data.isnull().sum())


# In[12]:


test_data.dropna(inplace=True)
print(test_data.isnull().sum())


# In[13]:


print(len(train_data),len(test_data))


# In[14]:


from konlpy.tag import Mecab
mecab = Mecab(dicpath=r"C:\mecab\mecab-ko-dic")


# In[15]:


stopwords = ['도', '는', '다', '의', '가', '이', '은', '한', '에', '하', '고', '을', '를', '인', '듯', '과', '와', '네', '들', '듯', '지', '임', '게','.','ㅋㅋㅋ','ㅋㅋ','거','냐']


# In[16]:


train_data['tokenized'] = train_data['sentence'].apply(mecab.morphs)


# In[17]:


train_data[5:10]


# In[18]:


train_data['tokenized'] = train_data['tokenized'].apply(lambda x: [item for item in x if item not in stopwords])
train_data[5:10]


# In[19]:


test_data['tokenized'] = test_data['sentence'].apply(mecab.morphs)
test_data['tokenized'] = test_data['tokenized'].apply(lambda x: [item for item in x if item not in stopwords])


# * ㅈㄹ, ㅅㅂ, ㅇㅁ 같은 걸 묶어서 토큰화 하는게 좋을 것 같음

# In[20]:


train_data['label'] = train_data['label'].astype('int')
test_data['label'] = test_data['label'].astype('int')


# In[21]:


bad = np.hstack(train_data[train_data.label==1]['tokenized'].values)
normal = np.hstack(train_data[train_data.label==0]['tokenized'].values)


# * label 1, 0 인 문장들에서 나오는 토큰 카운트 분석 (여기선 별 의미 없음)

# In[22]:


from collections import Counter
bad_count = Counter(bad)
print(bad_count.most_common(20))


# In[23]:


normal_count = Counter(normal)
print(normal_count.most_common(20))


# In[24]:


tokenizer = Tokenizer()
tokenizer.fit_on_texts(train_data['tokenized'])


# In[25]:


print(tokenizer.word_index)


# In[26]:


threshold = 2 # 임계값
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

print('단어 집합(vocabulary)의 크기 :',total_cnt)
print('등장 빈도가 %s번 이하인 희귀 단어의 수: %s'%(threshold - 1, rare_cnt))
print("단어 집합에서 희귀 단어의 비율:", (rare_cnt / total_cnt)*100)
print("전체 등장 빈도에서 희귀 단어 등장 빈도 비율:", (rare_freq / total_freq)*100)


# In[27]:


vocab_size = total_cnt - rare_cnt + 1
print('단어 집합의 크기 :',vocab_size)


# In[28]:


tokenizer = Tokenizer(vocab_size) 
tokenizer.fit_on_texts(train_data['tokenized'])
X_train = tokenizer.texts_to_sequences(train_data['tokenized'])
X_test = tokenizer.texts_to_sequences(test_data['tokenized'])


# In[29]:


print('(토큰 처리된)리뷰의 최대 길이 :',max(len(l) for l in X_train))
print('(토큰 처리된)리뷰의 평균 길이 :',sum(map(len, X_train))/len(X_train))
plt.hist([len(s) for s in X_train], bins=50)
plt.xlabel('length of samples')
plt.ylabel('number of samples')
plt.show()


# In[30]:


X_train[9] # 불용어처리 되어서 생긴 공백있음. 상관 없을 듯 (정규표현식 과정에서 생긴 공백은 없애주었음)


# In[31]:


def below_threshold_len(max_len, nested_list):
  cnt = 0
  for s in nested_list:
    if(len(s) <= max_len):
        cnt = cnt + 1
  print('전체 샘플 중 길이가 %s 이하인 샘플의 비율: %s'%(max_len, (cnt / len(nested_list))*100))


# In[32]:


max_len = 50
below_threshold_len(max_len, X_train)


# In[33]:


below_threshold_len(max_len, X_test)


# In[34]:


X_train = pad_sequences(X_train, maxlen = max_len)
X_test = pad_sequences(X_test, maxlen = max_len)


# # BERT

# In[ ]:


# pip install pytorch-transformers


# In[35]:


import torch
from torch.utils.data import Dataset, DataLoader
from pytorch_transformers import BertTokenizer, BertForSequenceClassification, BertConfig
from torch.optim import Adam
import torch.nn.functional as F


# In[36]:


class AbusiveSentenceDataset(Dataset):
    ''' Naver Sentiment Movie Corpus Dataset '''
    def __init__(self, df):
        self.df = df

    def __len__(self):
        return len(self.df)

    def __getitem__(self, idx):
        text = self.df.iloc[idx, 0]
        label = self.df.iloc[idx, 1]
        return text, label


# In[37]:


as_dataset = AbusiveSentenceDataset(X_train)
train_loader = DataLoader(as_dataset, batch_size=2, shuffle=True, num_workers=2)


# In[38]:


device = torch.device("cuda")
tokenizer = BertTokenizer.from_pretrained('bert-base-multilingual-cased')
model = BertForSequenceClassification.from_pretrained('bert-base-multilingual-cased')
model.to(device)


# In[ ]:


optimizer = Adam(model.parameters(), lr=1e-6)

itr = 1
p_itr = 500
epochs = 1
total_loss = 0
total_len = 0
total_correct = 0


model.train()
for epoch in range(epochs):
    
    for text, label in train_loader:
        optimizer.zero_grad()
        
        # encoding and zero padding
        encoded_list = [tokenizer.encode(t, add_special_tokens=True) for t in text]
        padded_list =  [e + [0] * (512-len(e)) for e in encoded_list]
        
        sample = torch.tensor(padded_list)
        sample, label = sample.to(device), label.to(device)
        labels = torch.tensor(label)
        outputs = model(sample, labels=labels)
        loss, logits = outputs

        pred = torch.argmax(F.softmax(logits), dim=1)
        correct = pred.eq(labels)
        total_correct += correct.sum().item()
        total_len += len(labels)
        total_loss += loss.item()
        loss.backward()
        optimizer.step()
        
        if itr % p_itr == 0:
            print('[Epoch {}/{}] Iteration {} -> Train Loss: {:.4f}, Accuracy: {:.3f}'.format(epoch+1, epochs, itr, total_loss/p_itr, total_correct/total_len))
            total_loss = 0
            total_len = 0
            total_correct = 0

        itr+=1

