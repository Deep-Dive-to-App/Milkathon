# 가상환경 : 우렁이의 forestella 사용
## 학습 코드
import numpy as np
# import json
from PIL import Image
import torch
import torch.nn as nn
import torch.optim as optim
from torch.optim import lr_scheduler
import matplotlib.pyplot as plt
import time
import os
import copy
import random
import torchvision

import argparse

from torchvision import transforms, datasets, models

# 나중에 device도 args에 넘겨주기
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")  # device 객체

random_seed = 555
random.seed(random_seed)
torch.manual_seed(random_seed)

## 데이터셋 만들기

def load_dataset():
    
    data_path = './data'
    train_datasets = datasets.ImageFolder(
        os.path.join(data_path, 'train'),
        transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
        ]))

    valid_datasets = datasets.ImageFolder(
        os.path.join(data_path, 'valid'),
        transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
        ]))

    test_datasets = datasets.ImageFolder(
        os.path.join(data_path, 'test'),
        transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
        ]))

    train_dataloader = torch.utils.data.DataLoader(train_datasets, batch_size=4, shuffle=True, num_workers=4)
    valid_dataloader = torch.utils.data.DataLoader(valid_datasets, batch_size=4, shuffle=True, num_workers=4)
    test_dataloader = torch.utils.data.DataLoader(test_datasets, batch_size=4, shuffle=True, num_workers=4)

    dataloaders = {
        'train': train_dataloader,
        'valid': valid_dataloader,
        'test': test_dataloader
    }

    dataset_sizes = {
        'train': len(train_datasets),
        'valid': len(valid_datasets),
        'test': len(test_datasets)
    }

    return dataloaders, dataset_sizes