# SepsisGPT
Binary Classification of Sepsis Development Using LLM Technology

This project was the final project of AI 380H AI in Healthcare within the Master’s of Artificial Intelligence online program at the Univeristy of Texas Austin. 

- The goal of this project is to detect sepsis in patients. We attempted two different approaches: fine tuning ‘gpt-35-turbo_0613’ and passing ‘text-embedding-ada-002’ embeddings to train ML models. 
- MIMIC-III data was parsed and used to create DataFrames used to train, test, and validate the models.
- Features were selected based on the medical definition of sepsis (Sepsis-2) during the time of MIMIC-III data collection. 
- Lastly, we analyzed the performance of the models, and a screening tool used by nurses in the literature, to compare their effectiveness.

HOW TO FOLLOW ALONG: 

The intention for this respository is just to serve as proof of work. Please read the MarthS_SmithN_WalkerJ_FinalProject.pdf and look through the .ipynb files for the detailed coding that was completed. However, the .ipynb files used in this repository depends upon access to the MIMIC-III database (which requires special institutional permission) and Azure OpenAI deployments. 
