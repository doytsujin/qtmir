file(GLOB BENCHMARK_FILES
	*.py
	*.R
)

install(FILES ${BENCHMARK_FILES}
    DESTINATION ${QTMIR_DATA_DIR}/benchmarks
)
