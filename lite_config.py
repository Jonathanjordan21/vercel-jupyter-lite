import os
from traitlets.config import get_config

c = get_config()
# Use the exact class name (try XeusPythonEnv first, or XeusPythonKernel if needed)
c.XeusPythonEnv.environment_file = os.path.join(os.getcwd(), "environment.yml")
c.XeusPythonEnv.kernel_name = "python"

print(f"✅ Config loaded: environment_file = {c.XeusPythonEnv.environment_file}")
