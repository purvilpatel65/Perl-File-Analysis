
#Author: Purvil Patel, All Rights Reserved
#BCS316 Final Project: Analyzing vgsales.csv
#
# Download all of the following modules in order to run the code:
#  1) Term::Menus
#  2) Term::ANSIColor
#  3) Text::CSV
#  4) Text::SimpleTable


#!/usr/bin/perl
use strict;
use warnings;

use Term::Menus;

use Win32::Console::ANSI;
use Term::ANSIColor;
use Term::ANSIColor qw(colored);

# The below module helps in efficiently reading .csv files than using split function. The reason is because when you have implicit commas in the columns itself, split() considers that commas as a separating delimiter and read
use Text::CSV;
# SimpleTable module helps in efficiently formatting and organizing data in table, which is easier to read and analyze.
use Text::SimpleTable;  




my $file = 'vgsales.csv';
if(defined $ARGV[0]){
  $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
}

open(my $data, $file) or die "Could not open '$file' $!\n"; #opens a file to read; if it cannot it dies and warn the user
 
#creating menus using menus module for the user to choose from
my @list=('list of all the sales for North America and others',
'Top sales by Platform',
'Top sales by Year',
'Top sales by Genre',
'Top sales by Publisher',
'Top sales by Platform given the year',
'Top sales by Genre given the year',
'Top sales by Publisher given the year',
'Game with the lowest sales',
'Game with the highest sales',
'Platform with the lowest sales',
'Platform with the highest sales',
'Publisher with the lowest sales',
'Publisher with the highest sales',
'Year with the lowest sales',
'Year with the highest sales',
);


my $banner="  Please Pick an Item:";
my $selection=&pick(\@list,$banner);

my $csv = Text::CSV->new({ sep_char => ',' }); #making a new object from csv module which separates the files using ',' delimeter


#1
if($selection eq 'list of all the sales for North America and others') {
my $tempCount = 0; #to count total number of lines
my @unParsedLines; #to store all unparsed lines because of special characters such as '~'
my $unParsedLinesNum; #to count total number of unparsed lines

my @eligibleGames; #to store all the eligible games
my @eligibleNASales; #to store all the North America's sales
my @eligibleOtherSales; #to store all the other sales from rest of the world

while (my $line = <$data>) {
chomp $line;

if ($csv->parse($line)) {
 
      if($tempCount eq 0){next;} #ignoring the first line because it doesn't contains useful info.
	  
      my @columns = $csv->fields(); #this separates all the fields from a line and store in an array
      	  
		
      my $other_total = $columns[10] - $columns[6];
      
	  push(@eligibleGames, $columns[1]);
	  push(@eligibleNASales, $columns[6]);
	  push(@eligibleOtherSales, $other_total);
  } else {
      $unParsedLinesNum++;
	  push(@unParsedLines, $line);
  }
$tempCount++;
}

my $t = Text::SimpleTable->new([60, 'Name'], [10, 'NA_Sales'], [10, 'Other_Sales']); #creating instance of table with appropriate columns names as headings

my $count = 0;
foreach(@eligibleGames){
$t->row($eligibleGames[$count], $eligibleNASales[$count], $eligibleOtherSales[$count]); #push data into table 
$t->hr; #draws lines between each row in table
$count++;
}
print colored($t->draw,'bright_green'); #displaying table

print"\n\nThere are $unParsedLinesNum unparsed lines which are as follows:\n";
foreach my $x(@unParsedLines){  #printing all the unparsed lines
print colored("\n$x", 'bright_red');
}

}

#2
if($selection eq 'Top sales by Platform') {

top_sales("Platform");
}

#3
if($selection eq 'Top sales by Year') {
top_sales("Year");

}

#4
if($selection eq 'Top sales by Genre') {
top_sales("Genre");

}

#5
if($selection eq 'Top sales by Publisher') {
top_sales("Publisher");

}

#6
if($selection eq 'Top sales by Platform given the year') {
top_sales_with_year("Platform");

}

#7
if($selection eq 'Top sales by Genre given the year') {
top_sales_with_year("Genre");

}

#8
if($selection eq 'Top sales by Publisher given the year') {
top_sales_with_year("Publisher");

}

#9
if($selection eq 'Game with the lowest sales') {
lowest_sales("Game");

}

#10
if($selection eq 'Game with the highest sales') {
highest_sales("Game");

}

#11
if($selection eq 'Platform with the lowest sales') {
lowest_sales("Platform");

}

#12
if($selection eq 'Platform with the highest sales') {
highest_sales("Platform");

}

#13
if($selection eq 'Publisher with the lowest sales') {
lowest_sales("Publisher");

}

#14
if($selection eq 'Publisher with the highest sales') {
highest_sales("Publisher");

}

#15
if($selection eq 'Year with the lowest sales') {
lowest_sales("Year");

}

#16
if($selection eq 'Year with the highest sales') {
highest_sales("Year");

}

#subroutine for analyzing top sales
sub top_sales{
       my ($type) = @_;

my $userInput;

#the below if statements check based on which criteria does user wants to analyze top sales
if(lc $type eq lc "Platform"){
print"\nEnter Platform: ";
$userInput = <STDIN>;
chomp $userInput;
}
if(lc $type eq lc "Year"){
print"\nEnter Year: ";
$userInput = <STDIN>;
chomp $userInput;
}
if(lc $type eq lc "Publisher"){
print"\nEnter Publisher: ";
$userInput = <STDIN>;
chomp $userInput;
}
if(lc $type eq lc "Genre"){
print"\nEnter Genre: ";
$userInput = <STDIN>;
chomp $userInput;
}

my @unParsedLines;
my $unParsedLinesNum;

my @eligibleGames;
my @eligibleSales;
my @eligibleRanks;

while (my $line = <$data>) {
chomp $line;

if ($csv->parse($line)) {
my @columns = $csv->fields();

my $eligibilityCheck = 0;

#the below if statements checks whether a parsed lines eligible for the data that user wants to analyze
if(lc $type eq lc "Platform"){
$eligibilityCheck = lc $userInput eq lc $columns[2];
}
if(lc $type eq lc "Year"){
$eligibilityCheck = lc $userInput eq lc $columns[3];
}
if(lc $type eq lc "Publisher"){
$eligibilityCheck = lc $userInput eq lc $columns[5];
}
if(lc $type eq lc "Genre"){
$eligibilityCheck = lc $userInput eq lc $columns[4];
}

if($eligibilityCheck){

#pushing readed columns into respected arrays
push(@eligibleGames, $columns[1]);
push(@eligibleSales, sprintf("%.3f", $columns[10]));
push(@eligibleRanks, $columns[0]);
}
}
else {
      $unParsedLinesNum++;
	  push(@unParsedLines, $line);
  }
}

my @idx = sort { $eligibleSales[$b] <=> $eligibleSales[$a] }0 .. $#eligibleSales; #sorting an array based on sales columns

@eligibleSales = @eligibleSales[@idx];
@eligibleGames = @eligibleGames[@idx];
@eligibleRanks = @eligibleRanks[@idx];

if(@eligibleGames){
my $t = Text::SimpleTable->new([5, 'Rank'], [60, 'Name'], [10, 'Sales']); #creating table again

my $count = 0;
foreach(@eligibleGames){
$t->row($eligibleRanks[$count], $eligibleGames[$count], $eligibleSales[$count]); #adding rows to table
$t->hr; #helps in separating each rows by lines
$count++;
}

print colored($t->draw,'bright_yellow'); #display colored table

print"\n\nThere are $unParsedLinesNum unparsed lines which are as follows:\n";
foreach my $x(@unParsedLines){  #printing all unparsed lines
print colored("\n$x", 'bright_red');
}
}
else{
print colored("No related data found!!", 'white on_blue');
}
}

#subroutine for analyzing top sales for specific year
sub top_sales_with_year{
       my ($type) = @_;

my $userInput;
my $userYear;

#again, checking which criteria user looking for!
if(lc $type eq lc "Platform"){
print"\nEnter Platform: ";
$userInput = <STDIN>;
chomp $userInput;

print"\nEnter Year: ";
$userYear = <STDIN>;
chomp $userYear;
}

if(lc $type eq lc "Publisher"){
print"\nEnter Publisher: ";
$userInput = <STDIN>;
chomp $userInput;

print"\nEnter Year: ";
$userYear = <STDIN>;
chomp $userYear;
}

if(lc $type eq lc "Genre"){
print"\nEnter Genre: ";
$userInput = <STDIN>;
chomp $userInput;

print"\nEnter Year: ";
$userYear = <STDIN>;
chomp $userYear;
}

my @unParsedLines;
my $unParsedLinesNum;

my @eligibleGames;
my @eligibleSales;
my @eligibleRanks;

while (my $line = <$data>) {
chomp $line;

if ($csv->parse($line)) {
my @columns = $csv->fields();

my $eligibilityCheck = 0;
if(lc $type eq lc "Platform"){
$eligibilityCheck = ((lc $userInput eq lc $columns[2]) && (lc $userYear eq $columns[3]));
}
if(lc $type eq lc "Year"){
$eligibilityCheck = ((lc $userInput eq lc $columns[3]) && (lc $userYear eq $columns[3]));
}
if(lc $type eq lc "Publisher"){
$eligibilityCheck = ((lc $userInput eq lc $columns[5]) && (lc $userYear eq $columns[3]));
}
if(lc $type eq lc "Genre"){
$eligibilityCheck = ((lc $userInput eq lc $columns[4]) && (lc $userYear eq $columns[3]));
}

if($eligibilityCheck){

push(@eligibleGames, $columns[1]);
push(@eligibleSales, sprintf("%.3f", $columns[10]));
push(@eligibleRanks, $columns[0]);
}
}
else {
      $unParsedLinesNum++;
	  push(@unParsedLines, $line);
  }
}

my @idx = sort { $eligibleSales[$b] <=> $eligibleSales[$a] }0 .. $#eligibleSales; #sorting an array based on top sales columns

#after sorting the above array,below we are sorting all the 'eligible' array based on index of above array as we need to sort all 'eligible' arrays with respect to decreasing order of top_sales
@eligibleSales = @eligibleSales[@idx];
@eligibleGames = @eligibleGames[@idx];
@eligibleRanks = @eligibleRanks[@idx];

if(@eligibleGames){
my $t = Text::SimpleTable->new([5, 'Rank'], [60, 'Name'], [10, 'Sales']);

my $count = 0;
foreach(@eligibleGames){
$t->row($eligibleRanks[$count], $eligibleGames[$count], $eligibleSales[$count]);
$t->hr;
$count++;
}

print colored($t->draw,'bright_blue');

print"\n\nThere are $unParsedLinesNum unparsed lines which are as follows:\n";
foreach my $x(@unParsedLines){
print colored("\n$x", 'bright_red');
}
}
else{
print colored("No related data found!!", 'white on_blue');
}

}


#subroutine to find lowest sales
sub lowest_sales{
       my ($type) = @_;
	   
my @unParsedLines;
my $unParsedLinesNum;
  
my %items; #using hash to store eligible items and its values as sales, which will be easier to compare based either keys or values
my $count = 0;

while (my $line = <$data>) {
chomp $line;

if($count eq 0){
$count++;
next;}

my $singleItem;
if ($csv->parse($line)) {
my @columns = $csv->fields();

if(lc $type eq lc "Platform"){
$singleItem = $columns[2];
}
if(lc $type eq lc "Year"){
$singleItem = $columns[3];
}
if(lc $type eq lc "Publisher"){
$singleItem = $columns[5];
}
if(lc $type eq lc "Game"){
$singleItem = $columns[1];
}

if (exists($items{$singleItem})){ #checking if the key already exist in the hash
$items{$singleItem} = $items{$singleItem} + $columns[10]; #if it does, it adds sales to its value everytime we hit the same key
}
else{
$items{$singleItem} = $columns[10];#if it does not then it adds a new key to hash and assign its value as a first sale
}

}
else {
      $unParsedLinesNum++;
	  push(@unParsedLines, $line);
  }
  
  
}


my @dataKeys = sort{ $items{$a} <=>  $items{$b}} keys %items; #sorting hash based on the values fields and storing the sorted keys in an array, as the result array will be all the keys sorted ascending way based on its values
my @dataValues = @items{@dataKeys}; #sorted values i.e sales in ascending order

print colored("\n$type with lowest sales is $dataKeys[0] by ". sprintf("%.3f", $dataValues[0])." sales.\n", 'white on_blue');


}

#subroutine to find highest sales
sub highest_sales{
       my ($type) = @_;
	   
my @unParsedLines;
my $unParsedLinesNum;
  
my %items;
my $count = 0;

while (my $line = <$data>) {
chomp $line;

if($count eq 0){
$count++;
next;}

my $singleItem;
if ($csv->parse($line)) {
my @columns = $csv->fields();

if(lc $type eq lc "Platform"){
$singleItem = $columns[2];
}
if(lc $type eq lc "Year"){
$singleItem = $columns[3];
}
if(lc $type eq lc "Publisher"){
$singleItem = $columns[5];
}
if(lc $type eq lc "Game"){
$singleItem = $columns[1];
}

if (exists($items{$singleItem})){ #checking whether key already present in hash
$items{$singleItem} = $items{$singleItem} + $columns[10]; #if it does, it adds sales to its value everytime we hit the same key
}
else{
$items{$singleItem} = $columns[10]; #if it does not, it add a new key and its respected sale as a new value
}

}
else {
      $unParsedLinesNum++;
	  push(@unParsedLines, $line);
  }
  
  
}


my @dataKeys = sort{ $items{$b} <=>  $items{$a}} keys %items; #sorting hash based on the values fields and storing the sorted keys in an array, as the result array will be all the keys sorted descending way based on its values
my @dataValues = @items{@dataKeys}; #sorted values i.e sales in descending order

print colored("\n$type with highest sales is $dataKeys[0] by ". sprintf("%.3f", $dataValues[0])." sales.\n", 'green on_white');



}

close($data); #closing the file


