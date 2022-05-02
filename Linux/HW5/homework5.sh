#!/bin/bash

mkdir Projects

cd Projects

wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1fRjFS1vOdS7yfKJgpJxR02_UxeT_qI_u' --output-document=TarDocs.tar

tar xvf TarDocs.tar

