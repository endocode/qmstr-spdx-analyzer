SPDX_ANALYZER := spdx-analyzer

$(SPDX_ANALYZER): wheels
	venv/bin/pex . pyqmstr -e spdxanalyzer.__main__:main --python=venv/bin/python3 --disable-cache -f ./wheels -o $@

venv: venv/bin/activate
venv/bin/activate: requirements.txt
	test -d venv || virtualenv -p python3 venv
	venv/bin/pip install -Ur requirements.txt
	touch venv/bin/activate

requirements.txt:
	echo pex >> requirements.txt
	echo autopep8 >> requirements.txt

wheels: venv
	venv/bin/pip wheel -w ./wheels git+https://github.com/QMSTR/pyqmstr

.PHONY: checkpep8
checkpep8: $(PYTHON_FILES) venv
	venv/bin/autopep8 --diff $(filter-out venv, $^)

.PHONY: autopep8
autopep8: $(PYTHON_FILES) venv
	venv/bin/autopep8 -i $(filter-out venv, $^)

.PHONY: pyqmstr-spdx-analyzer
pyqmstr-spdx-analyzer: $(SPDX_ANALYZER)

.PHONY: clean
clean:
	@rm -fr venv || true
	@rm -fr wheels || true
	@rm requirements.txt || true
	@rm spdx-analyzer || true
	@rm -rf pyqmstr_spdx_analyzer.egg-info || true
