import os
from gc import collect as gc
os.chdir("C:/Users/Tomoki/OneDrive/Documents/tobiipro")
import pandas as pd
import matplotlib.pyplot as plt

# sampling rate = 120Hz

df_ori = pd.read_csv("tobii3.tsv", sep="\t")
df_ori.rename(columns={"AOI hit [B3 - Trim - Rectangle]": "aoi"}, inplace=True)
df = df_ori.loc[38254:].reset_index(drop=True)
df_stim = df.loc[5621:6493].reset_index(drop=True)
df_stim.to_csv("all_gaze.csv", index=False)

df_stim_trim = df_stim.loc[:839, "aoi"]

aoi_ratios = []
for i in range(30, 841, 30):
    ratio = df_stim_trim.loc[i-30:i].mean()
    aoi_ratios.append(ratio)
pd.Series(aoi_ratios, name="aoi_ratio").to_csv("aoi_ratios.csv", index=False)

# 5621 VideoStimulusStart
# 6492 VideoStimulusEnd

def show_all(df):
    pd.set_option('display.max_rows', None) 
    if len(df) > 200:
        print("Too many rows to display!")
    else:
        print(df)
    pd.reset_option('display.max_rows', 5)        

cols = pd.Series(df.columns)
show_all(cols)

for col in cols:
    try:
        df[col].plot(title=f"{col}")
        plt.show()
    except:
        pass
    
    
