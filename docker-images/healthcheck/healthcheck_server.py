import http.server
import subprocess

class HealthCheckRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        # run the healthcheck subprocess
        try:
            process = subprocess.run(["python3", "healthcheck.py"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=true, timeout=20)
            if process.returncode == 0:
                self.send_response(200)
                self.send_header("Content-length", 0)
                self.end_headers()
                return
            # otherwise, we ran into an error
            self.send_response(400)
            self.send_header("Content-type", "text/plain")
            self.send_header("Content-length", str(len(process.stdout)))
            self.end_headers()
            self.wfile.write(process.stdout)
            return
        except:
            pass
        # otherwise, we ran into an unknown error
        self.send_response(500)
        self.send_header("Content-length", 0)
        self.end_headers()

httpd = server_class(('', 21337), HealthCheckRequestHandler)
httpd.serve_forever()