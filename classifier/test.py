import numpy as np
import json
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

import load_data as ld

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")  # device 객체

random_seed = 555
random.seed(random_seed)
torch.manual_seed(random_seed)

dataloaders, dataset_sizes = ld.load_dataset()

class_names = ['0', '1', '2', '3', '4']

class Test(object):
    def __init__(self, args):
        super().__init__()
        
        self.model = torch.load(args.model_pth)
        self.visualize = args.visualize
        
    def evaluation(self):
        
        self.model.eval()
        was_training = self.model.training
        
        count = 0
        num_images = 8
        with torch.no_grad():
            for i, (inputs, labels) in enumerate(dataloaders['test']):
                count += 1
                inputs = inputs.to(device)
                labels = labels.to(device)

                outputs = self.model(inputs)
                _, preds = torch.max(outputs, 1)

                for j in range(inputs.size()[0]):
                    if class_names[preds[j]] == '0':
                        print('strawberry', end=' ')
                    elif class_names[preds[j]] == '1':
                        print('banana', end=' ')
                    elif class_names[preds[j]] == '2':
                        print('choco', end=' ')
                    elif class_names[preds[j]] == '3':
                        print('coffee', end=' ')
                    else:
                        print('white', end=' ')
                        
                    if labels[j] == class_names[preds[j]]:
                        print("correct")
                    elif labels[j] != class_names[preds[j]]:
                        print("wrong")
                    
                    # test 이미지 한 번 섞어야 할 것 같은데.
                    
                    if count == num_images:
                        self.model.train(mode=was_training)
                        return
            self.model.train(mode=was_training)
            
            if self.visualize:
                visualize_model()
        
    def visualize_model(self, num_images=6):    
        was_training = self.model.training
        self.model.eval()
        images_so_far = 0
        fig = plt.figure()

        with torch.no_grad():
            for i, (inputs, labels) in enumerate(dataloaders['test']):
                inputs = inputs.to(device)
                labels = labels.to(device)

                outputs = model(inputs)
                _, preds = torch.max(outputs, 1)

                for j in range(inputs.size()[0]):
                    images_so_far += 1
                    ax = plt.subplot(num_images // 2, 2, images_so_far)
                    ax.axis('off')

                    if class_names[preds[j]] == '0':
                        ax.set_title('strawberry')
                    elif class_names[preds[j]] == '1':
                        ax.set_title('banana')
                    elif class_names[preds[j]] == '2':
                        ax.set_title('choco')
                    elif class_names[preds[j]] == '3':
                        ax.set_title('coffee')
                    else:
                        ax.set_title('white')

                    imsave(inputs.cpu().data[j])

                    if images_so_far == num_images:
                        model.train(mode=was_training)
                        return
            model.train(mode=was_training)


if __name__ == '__main__':
    # 모델 불러오기
    parser = argparse.ArgumentParser(description='parameters for model')
    
    parser.add_argument('--n_epochs', type=int, default=100, help='the number of epochs')
    parser.add_argument('--model_pth', type=str, default='milkathon_epoch100.pt', help='path where the model exists')
    parser.add_argument('--batch_size', type=int, default=4, help='batch size')
    parser.add_argument('--visualize', type=bool, default=False, help='do you want to visualize the results?')
    
    args = parser.parse_args()
    
    result = Test(args)
    result.evaluation()
    # result.visualize_model()
    
    