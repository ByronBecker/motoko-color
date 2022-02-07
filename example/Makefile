default:
	$(shell vessel bin)/moc $(shell vessel sources) -wasi-system-api -o main.wasm main.mo && wasmtime main.wasm
	rm -f main.wasm