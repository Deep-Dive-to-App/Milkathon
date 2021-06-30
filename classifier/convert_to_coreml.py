from PIL import Image

import torch
import torch.nn as nn
import torchvision
from torchvision import transforms

import coremltools as ct

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")  # device 객체
model = torch.load('milkathon_epoch100.pt').eval()

input_image = Image.open("test_img.jpg")

preprocess = transforms.Compose([
                transforms.Resize((224, 224)),
                transforms.ToTensor(),
                transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

input_tensor = preprocess(input_image).to(device)
input_batch = input_tensor.unsqueeze(0)

with torch.no_grad():
    outputs = model(input_batch)
    pred = torch.max(outputs)
    if pred == 0:
        print("strawberry")
    elif pred == 1:
        print("banana")
    elif pred == 2:
        print("choco")
    elif pred == 3:
        print("coffee")
    else:
        print("white")
    
# @register_torch_op
# def type_as(context, node):
#     inputs = _get_inputs(context, node)
#     context.add(mb.cast(x=inputs[0], dtype='int32'), node.name)
    
trace = torch.jit.trace(model, input_batch)
mlmodel = ct.convert(
    trace,
    inputs=[ct.ImageType(name="Image", shape=input_batch.shape)],
)

mlmodel.save("milk.mlmodel")
