# Lab: Transforming Data with Mapping Data Flow

You are ready to build a Mapping Data Flow which will transform your data at scale via a spark cluster and then load it into a Data Warehouse. 


## Task 1: open the Azure Data Factory

You might have closed the Azure Data Factory studio. If so, please follow this procedure to open it. If it is alread open, you can skip to task 2.

1. Sign in to the Azure portal.

1. In the left pane, select Resource Groups.

1. Select the ADF resource gorup.

1. In the ADF resource group, select your Azure Data Factory to open it.

1. Select the **Open Azure Data Factory Studio** link.

1. Alternatively, for the previous steps, you can open the Azure Data Factory by visiting the link https://adf.azure.com/ and signing in.


## Task 2: add a data flow activity


1. In the Activities pane, open the **Move and Transform** accordion and drag the **Data Flow** activity onto the pipeline canvas and connect with the **Copy data** activity we created earlier. 

    ![Adding a Mapping Data Flow in Azure Data Factory](images/M07-E03-T01-img01.png)

2. Turn the **Data Flow Debug** slider located at the top of the authoring module on, and click **OK** in the **Turn on data flow debug** screen that appears.  

    > NOTE: Data Flow clusters might take 5 minutes to warm up.


3. Select the data flow activity in the pipeline workspace. In the lower pane, select the settings tab, click **+ New** for the variable **Dataflow**

4. Click on the grey arrow next to **Add Source**. In the dropdown, select **Add Source**.

5. In the Dataset section, Click the down arrow and select the ADLS dataset you created in your Copy activity

    ![Adding a Source to a Mapping Data Flow in Azure Data Factory](images/M07-E03-T02-img01.png)


NIET MEER VAN TOEPASSING????????????
    * If your dataset is pointing at a folder with other files, you may need to create another dataset or utilize parameterization to make sure only the moviesDB.csv file is read
    * If you have not imported your schema in your ADLS, but have already ingested your data, go to the dataset's 'Schema' tab and click 'Import schema' so that your data flow knows the schema projection.
NIET MEER VAN TOEPASSING????????????


1. Click the **Test connection** button next to the dataset. Only proceed if the connection is succesfull.

1. Once your debug cluster is warmed up, verify your data is loaded correctly via the **Data preview** tab. Once you click the refresh button, Mapping Data Flow will show calculate a snapshot of what your data looks like when it is at each transformation.


## Task 3: Using Mapping Data Flow transformation

1. **Add a Select transformation to rename and drop a column**: In the preview of the data, you may have noticed that the "Rotton Tomato" column is misspelled. To correctly name it and drop the unused Rating column, you can add a [Select transformation](https://docs.microsoft.com/azure/data-factory/data-flow-select) by clicking on the + icon next to your ADLS source node and choosing **Select** under Schema modifier.
    
    ![Adding a Transformation to a Mapping Data Flow in Azure Data Factory](images/M07-E03-T03-img01.png)

    In the **Name as** field, under the **Select settings** tab, change 'Rotton' to 'Rotten'. To drop the Rating column, hover over it and click on the trash can icon.

    ![Using the Select Transformation to a Mapping Data Flow in Azure Data Factory](images/M07-E03-T03-img02.png)

2. **Add a Filter Transformation to filter out unwanted years**: Say you are only interested in movies made after 1951. You can add a [Filter transformation](https://docs.microsoft.com/azure/data-factory/data-flow-filter) to specify a filter condition by clicking on the **+ icon** next to your Select transformation and choosing **Filter** under Row Modifier. Click on the **expression box** to open up the [Expression builder](https://docs.microsoft.com/azure/data-factory/concepts-data-flow-expression-builder) and enter in your filter condition. Using the syntax of the [Mapping Data Flow expression language](https://docs.microsoft.com/azure/data-factory/data-flow-expression-functions), **toInteger(year) > 1950** will convert the string year value to an integer and filter rows if that value is above 1950.

    ![Using the Filter Transformation to a Mapping Data Flow in Azure Data Factory](images/M07-E03-T03-img03.png)

    When you clicked on **open expression builder** you can verify your condition is working properly. This will also show by a check mark in the **Filter on** textbox.

    ![Using the Expression Builder in the Mapping Data Flow in Azure Data Factory](images/M07-E03-T03-img04.png)


3. **Add a Derive Transformation to calculate primary genre**: As you may have noticed, the genres column is a string delimited by a '|' character. If you only care about the *first* genre in each column, you can derive a new column named **PrimaryGenre** via the [Derived Column](https://docs.microsoft.com/azure/data-factory/data-flow-derived-column) transformation by clicking on the **+ icon** next to your Filter transformation and choosing **Derived Column** under Schema Modifier. Similar to the filter transformation, the derived column uses the Mapping Data Flow expression builder to specify the values of the new column.

    ![Using the Derived Transformation to a Mapping Data Flow in Azure Data Factory](images/M07-E03-T03-img05.png)

    In this scenario, you are trying to extract the first genre from the genres column which is formatted as 'genre1|genre2|...|genreN'. Use the **locate** function to get the first 1-based index of the '|' in the genres string. Using the **iif** function, if this index is greater than 1, the primary genre can be calculated via the **left** function which returns all characters in a string to the left of an index. Otherwise, the PrimaryGenre value is equal to the genres field. You can verify the output via the expression builder's Data preview pane.

    - In the **Derived column's** settings tab, click **+Add** then, **Add column**, to add a column named **PrimaryGenre**. 
    - Under **Expression** open the **Expression builder**. 
    - Write iif(locate('|', genres)>1,left(genres,locate('|', genres)-1),genres)
    - Select **Save and finish**



4. **Rank movies via a Window Transformation** Say you are interested in how a movie ranks within its year for its specific genre. You can add a [Window transformation](https://docs.microsoft.com/azure/data-factory/data-flow-window) to define window-based aggregations by clicking on the **+ icon** next to your Derived Column transformation and clicking **Window** under Schema modifier. To accomplish this, specify what you are windowing over, what you are sorting by, what the range is, and how to calculate your new window columns. In this example, we will window over PrimaryGenre and year with an unbounded range, sort by Rotten Tomato descending, and calculate a new column called RatingsRank which is equal to the rank each movie has within its specific genre-year.


    - In the **Window settings** pane under the **Over** tab, select **PrimaryGenre** and add **year** by clicking on **+** and selecting **year** from the dropdown.

    ![Window Over](images/WindowOver.PNG "Window Over")

    - In the **Sort settings** pane, select the **Rotten Tomato** column, select **Descending** under **Order** and check **Nulls first**


    ![Window Sort](images/WindowSort.PNG "Window Sort")

   - In the **Range by settings** pane, leave all settings per default.

    ![Window Bound](images/WindowBound.PNG "Window Bound")

   - In the **Window columns settings** pane, rename the blank column to **RatingsRank** and enter as expression **rank()**


    ![Window Rank](images/WindowRank.PNG "Window Rank")

5. **Aggregate ratings with an Aggregate Transformation**: Now that you have gathered and derived all your required data, we can add an [Aggregate transformation](https://docs.microsoft.com/azure/data-factory/data-flow-aggregate) to calculate metrics based on a desired group by clicking on the **+ icon** next to your Window transformation and clicking **Aggregate** under Schema modifier. As you did in the window transformation, lets group movies by PrimaryGenre and year

    - Under the **Aggregate settings** tab, select **Group by**.
    - Using the dropdown select the column **Primary Genre** and add the **year** column by clicking **+**, and dropdown.
    
    ![Using the Aggregate Transformation to a Mapping Data Flow in Azure Data Factory](images/M07-E03-T03-img10.png)

    In the Aggregates tab, you can calculate aggregations over the specified group-by columns. For every genre and year, lets get the average Rotten Tomatoes rating, the highest and lowest rated movie (utilizing the windowing function) and the number of movies that are in each group. Aggregation significantly reduces the amount of rows in your transformation stream and only propagates the group by and aggregate columns specified in the transformation.

    - Under the **Aggregate settings** tab, now select **Aggregates**. Add the following columns by clicking **+** and then **Add column**, with their respective expressions:
        - AverageRating: avg(toInteger({Rotten Tomato}))
        - HighestRead: first(title)
        - LowestRead: last(title)
        - NumberOfMovies: count()


    ![Configuring the Aggregate Transformation to a Mapping Data Flow in Azure Data Factory](images/M07-E03-T03-img11.png)

    * To see how the aggregate transformation changes your data, use the Data preview tab.
   

6. **Specify Upsert condition via an Alter Row Transformation** If you are writing to a tabular sink, you can specify insert, delete, update and upsert policies on rows using the [Alter Row transformation](https://docs.microsoft.com/azure/data-factory/data-flow-alter-row) by clicking on the **+ icon** next to your Aggregate transformation and clicking **Alter Row** under Row modifier. Since you are always inserting and updating, you can specify that all rows will always be upserted.

    - From the dropdown next to **Alter row conditions** in the **Alter row settings** tab, please select **Upsert if**. In the expression write **true()**

    ![Using the Alter Row Transformation to a Mapping Data Flow in Azure Data Factory](images/M07-E03-T03-img12.png)

    * To see how the Alter Row transformation changes your data, use the Data preview tab.
    

### Task 4: Writing to a Data Sink

1. **Write to a Azure Synapse Analytics Sink**: Now that you have finished all your transformation logic, you are ready to write to a Sink.

    1. Add a **Sink** by clicking on the **+ icon** next to your Alter row transformation and clicking **Sink** under Destination.

    2. In the Sink tab, create a dataset via the **+ New button** next to **Dataset**.

    3. Select **Azure Blob Storage** from the tile list and click **Continue**

    3. Select the **DelimitedText** format tile and click **Continue**.

    4. In Set Properties blade, give your dataset this name: **RankedMovies** and click on the **Linked Service** dropdown. Select **New**.

    5. In the New linked service blade, select your authentication method as **Account key**, select your **Azure Subscription** and select your Storage account. You will see a screen as follows:

    ![Create a Sink in Azure Data Factory in the Azure Portal](images/M07-E02-T03-img01.png)

    6. Click the **Test connection** button in the lower right corner of the screen. If the test is succesfull, click on **Create**.

    7. Once you have configured your linked service, you enter the set properties blade. Respectively, specify **data** as the containter/file system. Specify **output** as the Directory, and enter **RankedMovies.csv** as the File name.

    8. Set **First row as header** to be true. Select Import Schema: **From connection/store**.





    UITWERKEN!!!!!!!!!!!!!!!!!!!!!!!!!!!

    ![Setting properties of a Sink in Azure Data Factory in the Azure Portal](images/M07-E02-T03-img02.png)

    10. Click **OK** once completed.












    13. Since an upsert condition was specified, you need to go to the Settings tab and select **Allow upsert**.
    
    14. For **Key columns** select **List of Columns** and add through **+** the two columns PrimaryGenre and year. based on key columns PrimaryGenre and year.
    ![Configuring Sink settings in Azure Data Factory](images/M07-E03-T04-img03.png)

    15. In the **Mapping** pane make sure you untick **Auto mapping**. 

At this point, You have finished building your 8 transformation Mapping Data Flow. It's time to run the pipeline and see the results!

![Completed Mapping Data Flow in Azure Data Factory](images/M07-E03-T04-img04.png)


## Task 5: Running the Pipeline

1. Go to the pipeline1 tab in the canvas. 


Because Azure Synapse Analytics in Data Flow uses [PolyBase](https://docs.microsoft.com/sql/relational-databases/polybase/polybase-guide?view=sql-server-2017), you must specify a blob or ADLS staging folder. In the **Settings** tab of the data flow, open up the **Staging** accordion and select your ADLS linked service and specify a staging folder path such as **data/dw-staging**.

    ![PolyBase configuration in Azure Data Factory](images/M07-E03-T05-img01.png)



2. Before you publish your pipeline, run another debug run to confirm it's working as expected. Looking at the **Output** tab, you can monitor the status of both activities as they are running.

3. Once both activities succeeded, you can click on the eyeglasses icon next to the Data Flow activity to get a more in depth look at the Data Flow run.

4. If you used the same logic described in this lab, your Data Flow should have written 737 rows to your SQL DW.

5. To verify this number navigate to you Synapse workspace. 

6. In your Synapse workspace, navigate to the **Data** hub. 

7. Under **Databases** select the **DWDB(SQL)** database and expand through the ellipses. 

8. Click the 3 dots next to the **DWDB(SQL)** database and select **New SQL script** followed by **Empty script**. Make sure the notebook is connected to **DWDB** and uses database **DWDB**. 
and paste: Select count(*) as TotalCount from dbo.Ratings


    ![Querying the results in Synapse Studio](images/M07-E03-T05-img02.png)


type: Dataset
SQL
lege tabel

type: inline
SQL
lege tabel