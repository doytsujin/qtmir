add_custom_target(autopilot)

function(declare_autopilot_test TEST_NAME TEST_SUITE WORKING_DIR)
    add_custom_target(autopilot-${TEST_NAME}
        COMMAND LANG=C UBUNTU_ICON_THEME=ubuntu-mobile QML2_IMPORT_PATH=${QTMIR_INSTALL_QML}/mocks python3 -m autopilot.run run ${TEST_SUITE}
        WORKING_DIRECTORY ${WORKING_DIR}
        DEPENDS fake_install
    )

    add_custom_target(fake_install
        COMMAND cmake --build ${CMAKE_BINARY_DIR} --target install
    )

    add_dependencies(autopilot autopilot-${TEST_NAME})

    add_custom_target(autopilot2-${TEST_NAME}
        COMMAND LANG=C UBUNTU_ICON_THEME=ubuntu-mobile QML2_IMPORT_PATH=${QTMIR_INSTALL_QML}/mocks python2 -m autopilot.run run ${TEST_SUITE}
        WORKING_DIRECTORY ${WORKING_DIR}
        DEPENDS fake_install
    )

    add_dependencies(autopilot autopilot2-${TEST_NAME})

endfunction()
