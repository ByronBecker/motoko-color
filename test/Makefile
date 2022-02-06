default:
	$(shell vessel bin)/moc $(shell vessel sources) -wasi-system-api -o WriterTest.wasm WriterTest.mo && wasmtime WriterTest.wasm
	rm -f WriterTest.wasm
