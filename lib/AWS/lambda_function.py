import sys
import subprocess
import io
import os

def handler(event, context):
    language = event.get("language", "python")
    code = event.get("code", "")
    if language == "python":
        result = execute_python_code(code)
    elif language == "java":
        result = execute_java_code(code)
    elif language == "cpp":
        result = execute_cpp_code(code)
    else:
        result = {"error": "UNSUPPORTED LANGUAGE"}
    return {
        "StatusCode": 200,
        "body": result
    }

def execute_python_code(code):
    try:
        old_stdout = sys.stdout
        old_stderr = sys.stderr
        sys.stdout = io.StringIO()
        sys.stderr = io.StringIO()
        exec(code, {'__name__': '__main__'})
        stdout_output = sys.stdout.getvalue()
        stderr_output = sys.stderr.getvalue()
        sys.stdout = old_stdout
        sys.stderr = old_stderr
        return {
            "stdout": stdout_output,
            "stderr": stderr_output
        }
    except Exception as e:
        sys.stdout = old_stdout
        sys.stderr = old_stderr
        return {
            "error": str(e)
        }
def execute_java_code(code):
    try:
        print('this is the code that we have received', code)
        with open('/tmp/Main.java', 'w') as java_file:
            java_file.write(code)
        compile_result = subprocess.run(
            ['javac', '/tmp/Main.java'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print('Compilation result:', compile_result.returncode)
        if compile_result.returncode != 0:
            return compile_result.stderr.decode()
        run_result = subprocess.run(
            ['java', '-classpath', '/tmp', 'Main'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        print('Run result:', run_result.returncode)
        return run_result.stdout.decode()
    except Exception as e:
        return str(e)
    
def execute_cpp_code(code):
    try:
        print('This is the code that we have received:\n', code)
        with open('/tmp/temp.cpp', 'w') as cpp_file:
            cpp_file.write(code)
        compile_result = subprocess.run(
            ['g++', '/tmp/temp.cpp', '-o', '/tmp/temp'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print('Compilation result:', compile_result.returncode)
        if compile_result.returncode != 0:
            return compile_result.stderr.decode()
        run_result = subprocess.run(
            ['/tmp/temp'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPEm
        )
        print('Run result:', run_result.returncode)
        return run_result.stdout.decode()
    except Exception as e:
        return str(e)
