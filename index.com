
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0">

  <title>AR - Khám phá hệ Mặt Trời</title>

  <script src="https://aframe.io/releases/1.5.0/aframe.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/mind-ar@1.2.5/dist/mindar-image-aframe.prod.js"></script>

  <style>
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: #10172b;
    }

    #lesson {
      position: fixed;
      top: 12px;
      left: 12px;
      right: 12px;
      z-index: 10;
      padding: 14px;
      border-radius: 14px;
      color: white;
      background: rgba(16, 23, 43, 0.92);
      text-align: center;
    }

    #lesson h2 {
      margin: 0 0 8px;
      font-size: 20px;
    }

    #lesson p {
      margin: 6px 0;
      font-size: 14px;
    }

    #quiz button {
      margin: 4px;
      padding: 9px 12px;
      border: 0;
      border-radius: 8px;
      cursor: pointer;
      background: #ffcf5c;
      color: #222;
    }

    #result {
      font-weight: bold;
      color: #9df7bd;
    }

    #status {
      font-size: 13px;
      color: #b9d8ff;
    }
  </style>
</head>

<body>
  <div id="lesson">
    <h2>🌞 KHÁM PHÁ HỆ MẶT TRỜI</h2>
    <p>Đưa camera vào hình ảnh mục tiêu để khám phá mô hình 3D.</p>
    <p id="status">Đang chuẩn bị camera...</p>

    <div id="quiz">
      <p><b>Câu hỏi:</b> Mặt Trời là gì?</p>
      <button onclick="checkAnswer('A')">
        A. Một ngôi sao
      </button>
      <button onclick="checkAnswer('B')">
        B. Một hành tinh
      </button>
      <p id="result"></p>
    </div>
  </div>

  <a-scene
    mindar-image="
      imageTargetSrc: https://cdn.jsdelivr.net/gh/hiukim/mind-ar-js@1.2.5/examples/image-tracking/assets/card-example/card.mind;
      autoStart: true;
    "
    color-space="sRGB"
    renderer="colorManagement: true"
    vr-mode-ui="enabled: false"
    device-orientation-permission-ui="enabled: false">

    <a-assets>
      <img
        id="targetImage"
        src="https://cdn.jsdelivr.net/gh/hiukim/mind-ar-js@1.2.5/examples/image-tracking/assets/card-example/card.png">
    </a-assets>

    <a-camera
      position="0 0 0"
      look-controls="enabled: false">
    </a-camera>

    <a-entity
      mindar-image-target="targetIndex: 0"
      id="arTarget">

      <!-- Hình ảnh mục tiêu -->
      <a-plane
        src="#targetImage"
        width="1"
        height="0.552"
        position="0 0 0">
      </a-plane>

      <!-- Mô hình Mặt Trời -->
      <a-sphere
        position="0 0.48 0.15"
        radius="0.20"
        color="#FFB627"
        material="emissive: #FF7A00; emissiveIntensity: 0.8"
        animation="
          property: rotation;
          to: 0 360 0;
          dur: 8000;
          loop: true;
          easing: linear">
      </a-sphere>

      <!-- Các tia sáng trang trí -->
      <a-torus
        position="0 0.48 0.15"
        radius="0.28"
        radius-tubular="0.008"
        color="#FFE89A"
        rotation="25 0 0">
      </a-torus>

      <!-- Tên mô hình -->
      <a-text
        value="MAT TROI"
        position="0 0.12 0.18"
        align="center"
        color="#FFFFFF"
        width="1.5"
        side="double">
      </a-text>

      <!-- Kiến thức giáo dục -->
      <a-text
        value="Trung tam he Mat Troi"
        position="0 -0.02 0.18"
        align="center"
        color="#FFE89A"
        width="1.5"
        side="double">
      </a-text>

      <a-text
        value="Tu phat ra anh sang va nhiet"
        position="0 -0.13 0.18"
        align="center"
        color="#FFFFFF"
        width="1.4"
        side="double">
      </a-text>

    </a-entity>
  </a-scene>

  <script>
    const statusText = document.getElementById("status");
    const target = document.getElementById("arTarget");

    target.addEventListener("targetFound", () => {
      statusText.textContent =
        "Đã nhận diện hình ảnh! Hãy khám phá mô hình.";
    });

    target.addEventListener("targetLost", () => {
      statusText.textContent =
        "Chưa thấy hình mục tiêu. Hãy đưa camera lại gần.";
    });

    function checkAnswer(answer) {
      const result = document.getElementById("result");

      if (answer === "A") {
        result.textContent =
          "Chính xác! Mặt Trời là một ngôi sao.";
      } else {
        result.textContent =
          "Chưa đúng. Hãy thử lại nhé!";
      }
    }
  </script>
</body>
</html>
