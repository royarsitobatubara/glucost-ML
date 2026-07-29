# 🚀SERVER GLUCOST API

## 🏁 Starting
  ```powershell
  # Masuk ke folder ML
  cd server

  # Menginstal semua library dari file requirements.txt
  pip install -r requirements.txt

  ```

## ⚡ Quick Start
  ```powershell
    # Masuk ke folder ML 
    cd server
    
    # Jalankan API Server 
    uvicorn main:app --reload
  ```

## 🌐 Base URL:

```
http://localhost:8000
```

### 1. DIABETES

- 📍 Endpoint 

  ```
  POST /predict/diabetes
  ```

- 📩 Request Body

  ```json
  {
    "Pregnancies": 6,
    "Glucose": 148,
    "BloodPressure": 72,
    "SkinThickness": 35,
    "Insulin": 0,
    "BMI": 33.6,
    "DiabetesPedigreeFunction": 0.627,
    "Age": 50
  }
  ```

- 🟢 Success Response

  ```json
  {
    "prediction": 0,
    "status": "Tidak Diabetes",
    "probability_diabetes": 49.1,
    "probability_non_diabetes": 50.9
  }
  ```

- 📜 Response Description

  | Field                    | Description                      |
  | ------------------------ | -------------------------------- |
  | prediction               | 0 = Tidak Diabetes, 1 = Diabetes |
  | status                   | Hasil prediksi                   |
  | probability_diabetes     | Probabilitas diabetes (%)        |
  | probability_non_diabetes | Probabilitas tidak diabetes (%)  |


### 2. OBESITAS

- 📍 Endpoint

  ```
  POST /predict/obesitas
  ```
- 📩 Request Body

  ```json
  {
    "Gender": "Female",
    "Age": 23,
    "Height": 1.65,
    "Weight": 70.0,
    "family_history": "yes",
    "FAVC": "yes",
    "FCVC": 2.0,
    "NCP": 3.0,
    "CAEC": "Sometimes",
    "SMOKE": "no",
    "CH2O": 2.0,
    "SCC": "no",
    "FAF": 1.0,
    "TUE": 1.0,
    "CALC": "Sometimes",
    "MTRANS": "Public_Transportation"
  }
  ```

- 🟢 Success Response

  ```json
  {
      "result": "Overweight_Level_I",
      "confidence_score": 47.79,
      "Insufficient_Weight": "0.78%",
      "Normal_Weight": "33.39%",
      "Obesity_Type_I": "5.60%",
      "Obesity_Type_II": "0.00%",
      "Obesity_Type_III": "0.00%",
      "Overweight_Level_I": "47.79%",
      "Overweight_Level_II": "12.44%"
  }
  ```

- 📜 Response Description

  - 📜 Response Description

  | Field | Description |
  | :--- | :--- |
  | `result` | Kelas hasil klasifikasi obesitas tertinggi (misal: Overweight, Obesity Type I, dll.) |
  | `confidence_score` | Skor keyakinan model terhadap hasil klasifikasi dalam persen (`float`) |
  | `Insufficient_Weight` | Probabilitas/kemungkinan pengguna memiliki berat badan kurang (%) |
  | `Normal_Weight` | Probabilitas/kemungkinan pengguna memiliki berat badan normal (%) |
  | `Overweight_Level_I` | Probabilitas/kemungkinan pengguna berada di level Overweight I (%) |
  | `Overweight_Level_II` | Probabilitas/kemungkinan pengguna berada di level Overweight II (%) |
  | `Obesity_Type_I` | Probabilitas/kemungkinan pengguna berada di level Obesitas Tipe I (%) |
  | `Obesity_Type_II` | Probabilitas/kemungkinan pengguna berada di level Obesitas Tipe II (%) |
  | `Obesity_Type_III` | Probabilitas/kemungkinan pengguna berada di level Obesitas Tipe III (%) |

### 3. HEART ATTACK

- 📍 Endpoint

  ```
  POST /predict/heart_attack
  ```
- 📩 Request Body

  ```json
  {
    "gender": 1, # 1 untuk laki-laki, 0 untuk perempuan
    "age": 54,
    "body_mass_index": 29.2,
    "smoker": 1, # 1 untuk iya, 0 untuk tidak
    "systolic_blood_pressure": 145.0,
    "hypertension_treated": 1, # 1 untuk iya, 0 untuk tidak
    "family_history_of_cardiovascular_disease": 1, # 1 untuk iya, 0 untuk tidak
    "atrial_fibrillation": 0, # 1 untuk iya, 0 untuk tidak
    "chronic_kidney_disease": 0, # 1 untuk iya, 0 untuk tidak
    "rheumatoid_arthritis": 0, # 1 untuk iya, 0 untuk tidak
    "diabetes": 1, # 1 untuk iya, 0 untuk tidak
    "chronic_obstructive_pulmonary_disorder": 0, # 1 untuk iya, 0 untuk tidak
    "forced_expiratory_volume_1": 85.0
  }
  ```

- 🟢 Success Response

  ```json
  {
      "is_risk": 0,
      "risk_percentage": 46.0,
      "safe_percentage": 54.0,
      "message": "Aman / Risiko Rendah"
  }
  ```

- 📜 Response Description

  | Field | Tipe Data | Deskripsi |
  | :--- | :--- | :--- |
  | `is_risk` | `int` | Hasil biner risiko serangan jantung: `1` jika berisiko tinggi, `0` jika aman. |
  | `risk_percentage` | `float` | Tingkat probabilitas risiko pasien mengalami serangan jantung (%). |

### 4. STRESS

- 📍 Endpoint

  ```
  POST /predict/stress
  ```
- 📩 Request Body

  ```json
  {
    "Humidity": 79,
    "Step_count": 1000,
    "Temperature": 90
  }
  ```

- 🟢 Success Response

  ```json
  {
      "prediction": 2,
      "confidence_score": 64.0,
      "class_0_probability": 0.0,
      "class_1_probability": 36.0,
      "class_2_probability": 64.0,
      "message": "Prediksi stress berhasil."
  }
  ```


## 🛠️ Spesifikasi Teknologi

* **Framework:** FastAPI (Python 3.13)
* **Machine Learning Libraries:** Scikit-Learn, Joblib
* **Data Processing:** Pandas, NumPy
* **Data Validation:** Pydantic (BaseModel)
* **Web Server:** Uvicorn