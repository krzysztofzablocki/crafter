module Crafter
  extend self

  attr_reader :icon_versioning_script, :command_line_test_script

  @icon_versioning_script = %q[
commit=`git rev-parse --short HEAD`
branch=`git rev-parse --abbrev-ref HEAD`
version=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST_FILE}"`

function processIcon() {
    export PATH=$PATH:/usr/local/bin
    base_file=$1
    if [ ! -f $base_file ]; then return; fi

    target_file=`echo $base_file | sed "s/_base//"`
    target_path="${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/${target_file}"

    if [ $CONFIGURATION = "Release" ]; then
        cp ${base_file} $target_path
        return
    fi

    width=`identify -format %w ${base_file}`

    convert -background '#0008' -fill white -gravity center -size ${width}x40\
        caption:"${version} ${branch} ${commit}"\
        ${base_file} +swap -gravity south -composite ${target_path}
}

processIcon "Icon_base.png"
processIcon "Icon@2x_base.png"
processIcon "Icon-72_base.png"
processIcon "Icon-72@2x_base.png"
]


  @command_line_test_script = %q[
# Launch application using ios-sim and set up environment to inject test bundle into application
# Source: http://stackoverflow.com/a/12682617/504494

echo "ENTERING TEST SCRIPT"

if [ "$RUN_UNIT_TEST_WITH_IOS_SIM" = "YES" ]; then
echo "TESTING_"
test_bundle_path="$BUILT_PRODUCTS_DIR/$PRODUCT_NAME.$WRAPPER_EXTENSION"
ios-sim launch "$(dirname "$TEST_HOST")" --setenv DYLD_INSERT_LIBRARIES=/../../Library/PrivateFrameworks/IDEBundleInjection.framework/IDEBundleInjection --setenv XCInjectBundle="$test_bundle_path" --setenv XCInjectBundleInto="$TEST_HOST" --args -SenTest All "$test_bundle_path"
echo "Finished running tests with ios-sim"
else
#"${SYSTEM_DEVELOPER_DIR}/Tools/RunUnitTests"
fi
]

end
