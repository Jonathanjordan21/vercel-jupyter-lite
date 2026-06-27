import os
from traitlets.config import get_config

c = get_config()

# This tells Xeus where to find the conda environment
c.XeusPythonEnv.environment_file = os.path.join(os.getcwd(), "environment.yml")

# This tells empack which file-filter YAML to use – MUST be set!
c.XeusPythonEnv.pack_config = os.path.join(os.getcwd(), "pack_config.yml")

c.XeusPythonEnv.kernel_name = "python"

print(f"✅ environment_file = {c.XeusPythonEnv.environment_file}")
print(f"✅ pack_config      = {c.XeusPythonEnv.pack_config}")
