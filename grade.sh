CPATH=".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar"

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -f ListExamples.java ]]
then 
    echo "ListExamples found"
else
    echo "Exit code:" $?
    echo "File ListExamples.java not found, check if file is named correctly"
    exit
fi

cd ..

cp student-submission/ListExamples.java ListExamples.java

javac -cp $CPATH *.java


exitCode=$?
if [[ $exitCode -ne 0 ]]
then
    echo "Exit code:" $exitCode
    echo "Files failed to compile"
    exit $exitCode
else
    echo "Files compiled successfuly"
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > errors.txt

exitCode=$?

error=$(grep -m1 "testMergeRightEnd" errors.txt) 
expected=$(grep -m1 "expected" errors.txt)

if [[ $exitCode -ne 0 ]]
then
    echo "Exit code:" $exitCode 
    echo ""
    echo "Test failed:" $error
    echo "Check if your merge method works as intended for the following 
    2 arrays: {\"a\", \"b\", \"c\"}, {\"a\", \"b\"}."
    echo $expected
    echo ""
    echo "Errors found, grade: Fail"
    exit $exitCode
else
    echo "No errors found, grade: Pass"
fi