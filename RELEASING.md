# Releasing QuilttConnector

This guide provides step-by-step instructions for releasing a new version of the QuilttConnector iOS package. Follow these steps to ensure a smooth and consistent release process.

## Prerequisites

1.  Ensure you have the following installed:

    - [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
    - [Bundler](https://bundler.io/)
    - [Fastlane](https://docs.fastlane.tools/getting-started/ios/setup/)
    - [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

2.  Clone the repository and navigate to the project directory:

    ```sh
    git clone git@github.com:quiltt/quiltt-ios.git
    cd quiltt-ios
    ```

3.  Install the required gems:

    ```sh
    bundle install
    ```

4.  Ensure you have a valid GitHub token with repository access set as an environment variable:

    ```sh
    export GITHUB_TOKEN=<your_github_token>
    ```

## Release Process

1.  Bump Version
    Determine the type of release you need to perform:

    - Patch Release: For bug fixes and small changes.
    - Minor Release: For new features that are backward-compatible.
    - Major Release: For changes that break backward compatibility.

    Run the appropriate Fastlane lane to bump the version and create a release branch:

    Patch Release:

    ```sh
    bundle exec fastlane release_patch
    ```

    Minor Release:

    ```sh
    bundle exec fastlane release_minor
    ```

    Major Release:

    ```sh
    bundle exec fastlane release_major
    ```

2.  Build Example App
    For Minor and Major releases, build the example app to ensure everything compiles correctly:

    ```sh
    bundle exec fastlane build_example_app
    ```

3.  Test the Release (Optional)
    Uncomment the testing steps in the Fastfile if you have tests available, and run them as part of the release process.

4.  Push to Remote and Create Pull Request
    The release lane will automatically:

    - Create a new branch for the release.
    - Bump the version number.
    - Push the branch to the remote repository.
    - Create a pull request for the release.
    - Review the pull request, and once it is approved, merge it into the main branch.

5.  Publish the Release
    The release lane will also:

    - Create a new GitHub release.
    - Generate release notes.
    - Tag the release.

After the pull request is merged, verify that the new release is listed on the GitHub releases page.

## Additional Information

The Fastfile contains lanes for automating the release process. Adjust the lanes as necessary to fit your specific requirements.

The `generate_release_version_file` method in the Fastfile will update the `QuilttSdkVersion.swift` file with the new version number.

Ensure that all changes are committed and pushed to the repository before starting the release process.
By following these steps, you can efficiently manage and release new versions of the QuilttConnector iOS package.
