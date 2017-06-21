all: creduce

clsmith:
	mkdir -pv build_clsmith
	cd build_clsmith && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install ../CLSmith -G Ninja
	cmake --build ./build_clsmith --target install --config Release

llvm: clsmith
	mkdir -pv build_llvm
	cd build_llvm && cmake -DLLVM_EXTERNAL_CLANG_SOURCE_DIR=../clang -DLLVM_TARGETS_TO_BUILD=X86 -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install ../llvm -G Ninja
	cmake --build ./build_llvm --target install --config Release

oclgrind: llvm
	mkdir -pv build_oclgrind
	cd build_oclgrind && cmake -DCMAKE_INSTALL_PREFIX=../instbball -DCMAKE_BUILD_TYPE=Release ../Oclgrind -G Ninja
	cmake --build ./build_oclgrind --target install --config Release

creduce: oclgrind
	mkdir -pv build_creduce
	cd build_creduce && cmake -DCMAKE_INSTALL_PREFIX=../install -DCMAKE_BUILD_TYPE=Release ../creduce -G Ninja
	cmake --build ./build_creduce --target install --config Release


.PHONY: clean
clean:
	rm -rf build_clsmith
	rm -rf build_llvm
	rm -rf build_oclgrind
	rm -rf build_creduce
