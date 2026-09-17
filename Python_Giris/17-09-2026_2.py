import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats

n = 1000

df = pd.DataFrame({
"musteri_id": range(1, n + 1),
"yas": np.random.normal(38, 12, n).round(0),
"gelir": np.random.lognormal(mean=10.5, sigma=0.6, size=n).round(2),
"sehir": np.random.choice(
["İstanbul", "Ankara", "İzmir", "Bursa", "istanbul", "ANKARA"],  # kasıtlı tutarsız yazım
size=n, p=[0.35, 0.2, 0.15, 0.1, 0.1, 0.1]
),
"abonelik_tipi": np.random.choice(["Temel", "Standart", "Premium"], size=n, p=[0.5, 0.35, 0.15]),
"kayit_tarihi": pd.date_range("2022-01-01", periods=n, freq="7h"),
"aylik_harcama": np.random.gamma(shape=2, scale=150, size=n).round(2),
"memnuniyet_puani": np.random.choice([1, 2, 3, 4, 5], size=n, p=[0.05, 0.1, 0.2, 0.35, 0.3]),
"churn": np.random.choice([0, 1], size=n, p=[0.8, 0.2]),
})


df.loc[df.sample(frac=0.08, random_state=1).index, "gelir"] = np.nan
df.loc[df.sample(frac=0.05, random_state=2).index, "yas"] = np.nan
df.loc[df.sample(frac=0.03, random_state=3).index, "memnuniyet_puani"] = np.nan
outlier_idx = df.sample(frac=0.01, random_state=4).index
df.loc[outlier_idx, "gelir"] = df["gelir"].max() * np.random.uniform(3, 6, len(outlier_idx))
df.loc[df.sample(frac=0.005, random_state=5).index, "yas"] = -5
df.loc[df.sample(frac=0.005, random_state=6).index, "yas"] = 150
df = pd.concat([df, df.sample(5, random_state=7)], ignore_index=True)

print(f"Veri Seti :{df.shape[0]} satır, {df.shape[1]} sütun")

print(df.shape)
eksik =df.isnull().sum()

def infos():
    print(f"DF INFO:\n{df.info}\n, DF HEADS\n{df.head}\n,DF TAILS \n{df.tail}\n,SAMPLE DATA\n{df.sample(5, random_state=1)}\n")

def sutunozet():
    print("\n ---- Sütun Özeti----")
    ozet = pd.DataFrame({
        "dtype": df.dtypes,
        "eksik_deger": df.isnull().sum(),
        "unique_deger": df.nunique(),
        "eksik_deger_yuzdesi": (df.isnull().mean() * 100).round(2),
    })

def eksik_deger_gorsellestir():
    plt.figure(figsize=(10, 6))
    sns.heatmap(df.isnull(), cbar=False, cmap="viridis", yticklabels=False)
    plt.title("eksik değerler")
    plt.tight_layout()
    plt.savefig("eksik_degerler.png", dpi=300)
    plt.show()

n_dup = df.duplicated().sum()
print(df["sehir"].value_counts())
print(n_dup)

df["sehir"] = df["sehir"].str.lower().str.strip()
df["sehir"] = df["sehir"].str.replace('i',"i").str.replace("ı","ı")
print(df[(df["yas"]< 0)|(df["yas"]>100)][["musteri_id","yas"]])
#df.describe()

sayisal_sutunlar =df.select_dtypes(include=[np.number]).columns.tolist()
sayisal_sutunlar.remove("musteri_id")

def carpikbasik():
    print("\n ---- Çapıklık/BAsıklık----")


    for col in sayisal_sutunlar:
      print(f"skew: {df[col].skew():.2f} kurt: {df[col].kurt():.2f}")

    fig, axes = plt.subplots(2, 3, figsize=(15, 6))
    for ax, col in zip(axes.flatten(), sayisal_sutunlar):
        sns.histplot(df[col], ax=ax, kde=True, bins=30)
        ax.set_title(col)
    plt.tight_layout()
    plt.savefig("histogramlar.png", dpi=300)
    plt.show()

    fig, axes = plt.subplots(2, 3, figsize=(15, 6))
    for ax, col in zip(axes.flatten(), sayisal_sutunlar):
        sns.boxplot(y=df[col], ax=ax)
        ax.set_title(col)
    plt.tight_layout()
    plt.savefig("boxplot.png", dpi=300)
    plt.show()

kategorik_sutünlar = ["sehir","abonelik_tipi","memnuniyet_puani","churn"]
for col in kategorik_sutünlar:

  print((df[col].value_counts(dropna=False, normalize=True)*100).round(2))

korelasyon = df[sayisal_sutunlar].corr(numeric_only=True)
print("------ Korelasyon Matrisi-----")
print(korelasyon.round(2))

def korelasyon_matrisi():
    plt.figure(figsize=(10, 6))
    sns.heatmap(korelasyon, annot=True, cmap="coolwarm")
    plt.title("Korelasyon Matrisi")
    plt.tight_layout
    plt.savefig("korelasyon_matrisi.png", dpi=300)
    plt.show()

korelasyon_matrisi()