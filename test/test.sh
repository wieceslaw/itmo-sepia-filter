cd ..
make all
cd test

result_md=../RESULT.md
echo "## Results" > $result_md
{
  echo
  for file in input/*; do
    echo "-----------------------"
    echo "### Test [$(basename "$file")](test/input/$(basename "$file"))"
    ./../build/sepia-filter-test "$file" "output/output_asm_$(basename "$file")" "output/output_c_$(basename "$file")"
    echo "### Source:"
    echo "![src](test/input/$(basename "$file"))"
    echo "### Result (asm impl):"
    echo "![output_asm](test/output/output_asm_$(basename "$file"))"
    echo "### Result (C impl):"
    echo "![output_c](test/output/output_c_$(basename "$file"))"
  done
  echo "-----------------------"
} >> $result_md
