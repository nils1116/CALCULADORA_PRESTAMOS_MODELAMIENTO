from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)

OCTAVE_PATH = r"C:\Program Files\GNU Octave\Octave-9.3.0\mingw64\bin\octave-cli.exe"

@app.route('/', methods=['GET', 'POST'])
def index():
    resultado = None
    error = None

    if request.method == 'POST':
        try:
            monto = float(request.form['monto'])
            tasa = float(request.form['tasa'])
            plazo = int(request.form['plazo'])

            # Construir el comando para ejecutar Octave y llamar a la función con parámetros
            comando = [
                OCTAVE_PATH,
                "--quiet",
                "--eval",
                f"calculo_prestamo({monto}, {tasa}, {plazo})"
            ]

            proceso = subprocess.run(comando, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

            if proceso.returncode != 0:
                error = f"Error al ejecutar Octave: {proceso.stderr}"
            else:
                resultado = proceso.stdout.strip()

        except Exception as e:
            error = f"Hubo un error al procesar tu solicitud: {str(e)}"

    return render_template('index.html', resultado=resultado, error=error)

if __name__ == '__main__':
    app.run(debug=True)
