-- Create a subquery to group and count nodes in the ADSL department by asset type and vendor
WITH DepartmentAssets AS (
    SELECT 
        AssetType,               -- Column for asset type
        Vendor,                  -- Column for vendor
        COUNT(NodeID) AS AssetCount  -- Count the number of nodes based on NodeID
    FROM 
        ENT_NCM
    WHERE 
        Department = 'ADSL'      -- Filter data for the ADSL department
    GROUP BY 
        AssetType, Vendor        -- Group by asset type and vendor
)

-- Main query to generate the final results
SELECT 
    -- Calculate the total number of nodes in the ADSL department
    'Department ADSL: ' || (SELECT SUM(AssetCount) FROM DepartmentAssets) AS TotalNodes,

    -- Generate a summary string for each vendor and their total device count
    STRING_AGG(DISTINCT Vendor || ': ' || SUM(AssetCount) OVER (PARTITION BY Vendor), ', ') AS VendorSummary,

    -- Generate a detailed summary string for each asset type, vendor, and their respective counts
    STRING_AGG(AssetType || ' ' || Vendor || ': ' || AssetCount, ', ') AS DetailedSummary

FROM 
    DepartmentAssets             -- Use the results from the subquery

GROUP BY 
    AssetType, Vendor, AssetCount; -- Group by asset type, vendor, and asset count to ensure distinct combinations

"
  Explanation:
  WITH DepartmentAssets AS (...):
  
  This section creates a subquery named DepartmentAssets to group and count nodes in the ADSL department based on asset type and vendor.
  AssetType: Column representing the type of asset.
  Vendor: Column representing the vendor.
  COUNT(NodeID) AS AssetCount: Counts the number of nodes (NodeID) for each combination of asset type and vendor.
  FROM ENT_NCM: Specifies the table to query data from.
  WHERE Department = 'ADSL': Filters the data to include only rows where the department is 'ADSL'.
  GROUP BY AssetType, Vendor: Groups the results by asset type and vendor to calculate counts for each combination.
  Main Query:
  
  'Department ADSL: ' || (SELECT SUM(AssetCount) FROM DepartmentAssets) AS TotalNodes:
  This part calculates the total number of nodes in the ADSL department by summing AssetCount from the DepartmentAssets subquery.
  The result is prefixed with the string 'Department ADSL: ' and named TotalNodes.
  STRING_AGG(DISTINCT Vendor || ': ' || SUM(AssetCount) OVER (PARTITION BY Vendor), ', ') AS VendorSummary:
  This part generates a summary string for each vendor and their total device count.
  STRING_AGG concatenates the results into a single string separated by commas.
  SUM(AssetCount) OVER (PARTITION BY Vendor) calculates the total count for each vendor.
  STRING_AGG(AssetType || ' ' || Vendor || ': ' || AssetCount, ', ') AS DetailedSummary:
  This part generates a detailed summary string for each asset type, vendor, and their respective counts.
  STRING_AGG concatenates the results into a single string separated by commas.
  FROM DepartmentAssets: Uses the results from the DepartmentAssets subquery.
  GROUP BY AssetType, Vendor, AssetCount: Groups the final results by asset type, vendor, and asset count to ensure distinct combinations.
"

