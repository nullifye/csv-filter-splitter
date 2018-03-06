# csv-filter-splitter
A Bash script tool for filtering and splitting CSV file. This tool is to help you split a large CSV into several CSV files based on filtered criteria(s).

# Introduction
I faced a situation recently in my work where i need to split up a csv file into several csv files, based on several criterias. And I  needed each file to be name after last criteria specified.

# Usage
```./dataSplitter <source-csv> <filters-csv> [-d]```

This will split the `<source-csv>`, making sure that every output matched all criteria(s) in `<filters-csv>`.

The only option is `-d`, which allows you to get the details of running process instead of plain progress bar.

# CSV Structure

## Source CSV
```
"title 1","title 2","title 3","title 4","title 5"
"data r1c1","data r1c2","data r1c3","data r1c4","data r1c5"
"data r2c1","data r2c2","data r2c3","data r2c4","data r2c5"
"data r3c1","data r3c2","data r3c3","data r3c4","data r3c5"

```

**Line 1** must be the *title* or *column name*.

**Line 2 and below** is the *raw data*.

You need to make sure the **last line** is an *empty line*.

## Filters CSV
```
$2,$4,$5
"filter 1", "filter 2", "filter 3"
"filter 1", "filter 2", "filter 3"
"filter 1", "filter 2", "filter 3"

```

**Line 1** must be the *column number* of filters to be applied based on source-csv, starting with **$**

**Line 2 and below** is the *filter values*.

You need to make sure the **last line** is an *empty line*.

Currently you can use up to 5 filters.

# Output
The `<source-csv>` will be splitting into several CSVs in `output` folder. You will be prompt the `output` folder name during the execution of the script. 

Naming conversion for the files is *{second_last_filter_value}*_*{last_filter_value}*.csv. And the folder structure also will follow the filter values. 

```output/filter_1/filter_2/filter2_filter_3.csv```

# Buy Me a Coffee

[paypal.me/mohdrafhan](https://www.paypal.me/mohdrafhan)
