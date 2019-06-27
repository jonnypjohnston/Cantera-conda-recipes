echo "****************************"
echo "LIBRARY TEST STARTED"
echo "****************************"

conda list
echo `which scons`
echo `which make`
echo `which cmake`

# Build and run the samples
declare -a samples=("rankine"
                    "NASA_coeffs"
                    "LiC6_electrode"
                    "combustor"
                    "flamespeed"
                    "kinetics1"
                   )

for sample in "${samples[@]}"; do
    pushd "${PREFIX}/share/cantera/samples/cxx/${sample}"
    scons && rm ${sample}.o ${sample} || exit 1
    make && rm ${sample} || exit 1
    if [[ "${OSX_ARCH}" == "" ]]; then
        # CMake doesn't work on macOS with the conda compilers, until LLVM v8
        # See: https://github.com/conda-forge/compilers-feedstock/issues/6
        mkdir build && pushd build && cmake .. && make && popd && rm -r build || exit 1
    fi
    popd
done

# This sample needs to be built separately because the name of the C++ file
# is different from the name of the folder
pushd "${PREFIX}/share/cantera/samples/cxx/bvp"
scons && rm blasius.o blasius || exit 1
make && rm blasius || exit 1
if [[ "${OSX_ARCH}" == "" ]]; then
    mkdir build && pushd build && cmake .. && make && popd && rm -r build || exit 1
fi
popd
