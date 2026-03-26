Drop table if EXISTS letters;
Create table letters (
  gid serial Primary Key,
  name varchar,
  statement varchar,
  geom geometry,
  showdate date
);

Drop Table If EXISTS message;
Create table message (
  gid serial Primary Key,
  geom geometry
);

INSERT INTO message (geom) VALUES (
    ST_SetSrid(
      ST_Translate(
        ST_Scale(
          ST_Letters('FOSSGIS 2026')
            , 0.00005, 0.00005),
         9.93603, 51.54159)
    , 4326));

--1 ----------------------------------------------------------------------------
--https://postgis.net/docs/ST_Scale.html
--https://postgis.net/docs/ST_Translate.html
--https://postgis.net/docs/ST_SetSrid.html
INSERT INTO letters (name,statement,geom) 
SELECT 'place text on Location',

'Select 
  ST_SetSrid(
    ST_Translate(
      ST_Scale(
        ST_Letters(''FOSSGIS 2026'')
      , 0.00005, 0.00005),
    9.93603, 51.54159), 
    4326);'
,
ST_SetSrid(ST_Translate(ST_Scale(
ST_Letters('FOSSGIS 2026')
, 0.00005, 0.00005),
9.93603, 51.54159), 4326);

--2 ----------------------------------------------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'Scale Text',

'Select 
  ST_SetSrid(
    ST_Translate(
      ST_Scale(
        ST_Letters(''FOSSGIS 2026'')
      , 0.00001, 0.00001,
    9.93603, 51.54159)
  , 4326);'
,
ST_SetSrid(ST_Translate(ST_Scale(
ST_Letters('FOSSGIS 2026')
, 0.00001, 0.00001),
9.93603, 51.54159), 4326);

--3 -------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'Scale Text',

'Select ST_SetSrid(ST_Translate(ST_Scale(
ST_Letters(''FOSSGIS 2026'')
, 0.00008, 0.00008),
9.93603, 51.54159), 4326)'
,
ST_SetSrid(ST_Translate(ST_Scale(
ST_Letters('FOSSGIS 2026')
, 0.00006, 0.00006),
9.93603, 51.54159), 4326);

--4 ----------------------------------------------------------------------------
-- https://postgis.net/docs/ST_ChaikinSmoothing.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_ChaikinSmoothing iteration 1',

'SELECT ST_ChaikinSmoothing(geom, 1, false) 
FROM message;'
,
ST_ChaikinSmoothing(geom, 1, false) 
FROM message;

--5 ----------------------------------------------------------------------------
--https://postgis.net/docs/ST_Translate.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_Translate - move up',

'SELECT 
  ST_Translate(geom,0,0.0008)
  FROM message;'
,
ST_Translate(geom,0,0.0008)
FROM message;

--6 -------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_Translate - move down',

'SELECT 
  ST_Translate(geom,0,-0.0008)
  FROM message;'
,
ST_Translate(geom,0,-0.0008)
FROM message;


--7 ----------------------------------------------------------------------------
--https://postgis.net/docs/ST_Rotate.html
INSERT INTO letters (name,statement,geom) 
SELECT 'Rotate 45 deegree around centroid',

'SELECT 
  ST_Rotate(geom, 45, ST_Centroid(geom)) 
  FROM message;'
,
ST_Rotate(geom, 45, ST_Centroid(geom)) 
FROM message;

--8 ---------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'Rotate 90 deegree around centroid',

'SELECT 
  ST_Rotate(geom, 90, ST_Centroid(geom)) 
  FROM message;'
,
ST_Rotate(geom, 90, ST_Centroid(geom)) 
FROM message;

--9 ----------------------------------------------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'Buffer via ST_Buffer',

'SELECT 
  ST_Buffer(geom, 0.0002)
  FROM message;'
,
ST_Buffer(geom, 0.0002)
FROM message;

--10 ---------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'Buffer via ST_Buffer quad_segs=1',

'SELECT 
  ST_Buffer(geom, 0.0002, ''quad_segs=1'') 
  FROM message;'
,
ST_Buffer(geom,0.0002,'quad_segs=1')
FROM message;

--11 ----------------------------------------------------------------------------
--https://postgis.net/docs/ST_Envelope.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_Envelope',

'SELECT 
  ST_Envelope(geom)
  FROM message;'
,
ST_Envelope(geom)
FROM message;

--12 ---------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_Envelope for every letter',

'SELECT ST_Union(geom) FROM 
(
  SELECT 
    ST_Envelope((ST_dump(geom)).geom) as geom 
    FROM message
) as foo;'
,
ST_Union(geom) FROM (
SELECT 
ST_Envelope((ST_dump(geom)).geom) as geom 
FROM message) as foo;

--13 --------------------------------------
--https://postgis.net/docs/ST_MinimumBoundingCircle.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_MinimumBoundingCircle',

'SELECT ST_MinimumBoundingCircle(geom) 
FROM message;'
,
ST_MinimumBoundingCircle(geom) 
FROM message;


--14 ----------------------------------------------------------------------------
--https://postgis.net/docs/ST_GeneratePoints.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_GeneratePoints 100',

'SELECT 
  ST_Union(
    ST_Buffer(
      ST_GeneratePoints(geom , 100, 1996),
    0.00001)
  )
  FROM message;'
,
ST_Union(ST_Buffer(ST_GeneratePoints(geom , 100, 1996),0.00008))
FROM message;

--15 ---------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_GeneratePoints 1000',

'SELECT 
  ST_Union(
    ST_Buffer(
      ST_GeneratePoints(geom , 1000, 1996),
    0.00001)
  )
  FROM message;'
,
ST_Union(ST_Buffer(ST_GeneratePoints(geom , 1000, 1996),0.00005))
FROM message;


--16 ----------------------------------------------------------------------------

--https://postgis.net/docs/ST_Dump.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_Dump all these Points & buffer',

'SELECT ST_Collect(geom) FROM 
(SELECT 
  (ST_Dump(ST_GeneratePoints(geom , 500, 1996))).path[1] , 
  ST_Buffer((ST_Dump(ST_GeneratePoints(geom , 600, 1996))).geom, 0.0005) as geom 
    FROM message
) as foo;'
,
ST_Collect(geom) FROM 
(
SELECT (ST_Dump(ST_GeneratePoints(geom , 500, 1996))).path[1] , 
ST_Buffer((ST_Dump(ST_GeneratePoints(geom , 600, 1996))).geom, 0.0005) as geom 
FROM message
) as foo;


--17 ----------------------------------------------------------------------------

--https://postgis.net/docs/ST_Intersection.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_Intersection - buffer all points & intersect',

'SELECT ST_CollectionExtract(ST_Collect(geom),3) FROM 
(SELECT 
  (ST_Dump(ST_GeneratePoints(geom , 500, 1996))).path[1] , 
  ST_Intersection(ST_Buffer((ST_Dump(ST_GeneratePoints(geom ,600, 1996))).geom, 0.0005),geom) as geom 
    FROM message
) as foo;'
,
ST_CollectionExtract(ST_Collect(geom),3) FROM 
(
SELECT (ST_Dump(ST_GeneratePoints(geom , 500, 1996))).path[1] , 
ST_Intersection(ST_Buffer((ST_Dump(ST_GeneratePoints(geom ,600, 1996))).geom, 0.0005),geom) as geom 
FROM message
) as foo;

--18 ----------------------------------------------------------------------------

--https://postgis.net/docs/ST_LineFromMultiPoint.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_LineFromMultiPoint',

'SELECT 
  ST_Buffer(
    ST_LineFromMultiPoint(
     ST_GeneratePoints(geom , 100, 1996)
    )
  ,0.00005)
  FROM message;'
, 
ST_Buffer(ST_LineFromMultiPoint(ST_GeneratePoints(geom , 100, 1996)),0.00005) 
FROM message;


--19 ----------------------------------------------------------------------------
--https://postgis.net/docs/ST_Subdivide.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_Subdivide',

'SELECT ST_Collect(geom) FROM 
(SELECT 
    ST_Subdivide(geom,5) as geom
    FROM message
) as foo;'
,
ST_Collect(geom) FROM (
SELECT ST_Subdivide(geom,5) as geom
FROM message) as foo;

--20 ----------------------------------------------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_HexagonGrid with ST_Intersects',

'SELECT ST_Collect(hex.geom) 
FROM 
  message m
CROSS JOIN
  ST_HexagonGrid(0.0002, m.geom) AS hex
WHERE ST_Intersects(m.geom, hex.geom);'
,
ST_Collect(hex.geom) 
FROM 
  message m
CROSS JOIN
    ST_HexagonGrid(0.0002, m.geom) AS hex
WHERE ST_Intersects(m.geom, hex.geom);

--21 ---------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_HexagonGrid with ST_Overlaps',

'SELECT ST_Collect(hex.geom) 
FROM 
  message m
CROSS JOIN
  ST_HexagonGrid(0.0002, m.geom) AS hex
WHERE ST_Overlaps(m.geom, hex.geom);'
,
ST_Collect(hex.geom) 
FROM message m
CROSS JOIN
    ST_HexagonGrid(0.0002, m.geom) AS hex
WHERE ST_Overlaps(m.geom, hex.geom);



--22 ----------------------------------------------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_Split',

'SELECT 
ST_CollectionExtract(
  ST_Split(geom, 
    ST_setsrid(ST_MakeLine (
      ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
      ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)))
    ,4326)
   )
,3) as geom 
FROM message;'
, 
ST_CollectionExtract(
ST_Split(geom, 
ST_setsrid(ST_MakeLine (
ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)))
,4326)),3) as geom 
FROM message;


--23----------------------------------------------------------------------------
-- https://postgis.net/docs/reference.html#Operators
-- https://postgis.net/docs/ST_Geometry_Overabove.html
INSERT INTO letters (name,statement,geom) 
SELECT 'Operator |&>  - A''s bounding box overlaps or is above B''s',

'SELECT (dump).geom FROM 
(SELECT ST_collect((dump).geom) FROM 
(SELECT ST_Dump(ST_Split(geom, 
  ST_setsrid(ST_MakeLine (
  ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
  ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)))
  ,4326))) as dump, geom FROM message) as foo WHERE (dump).geom |&>  
ST_setsrid(ST_MakeLine (
  ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
  ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2))),4326);'

, 
ST_collect((dump).geom) FROM 
(
SELECT ST_Dump(ST_Split(geom, 
ST_setsrid(ST_MakeLine (
ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)))
,4326))) as dump,
geom 
FROM (
SELECT geom 
FROM message) as foo) as foo2
WHERE (dump).geom  |&> 
ST_setsrid(ST_MakeLine (
ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2))),4326)
;


--24----------------------------------------------------------------------------
-- https://postgis.net/docs/reference.html#Operators
-- https://postgis.net/docs/ST_Geometry_Overbelow.html
INSERT INTO letters (name,statement,geom) 
SELECT 'Operator &<| - A''s bounding box overlaps or is below B''s',

'SELECT (dump).geom FROM 
(SELECT ST_collect((dump).geom) FROM 
(SELECT ST_Dump(ST_Split(geom, 
  ST_Setsrid(ST_MakeLine (
  ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
  ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2))),4326))) as dump,
geom FROM message) as foo WHERE (dump).geom &<| 
ST_setsrid(ST_MakeLine (
  ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
  ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2))),4326);'
, 
ST_collect((dump).geom) FROM 
(
SELECT ST_Dump(ST_Split(geom, 
ST_setsrid(ST_MakeLine (
ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)))
,4326))) as dump,
geom 
FROM message) as foo
WHERE (dump).geom &<| 
ST_setsrid(ST_MakeLine (
ST_MakePoint(ST_Xmin(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2)), 
ST_MakePoint(ST_Xmax(geom) , ST_ymin(ST_envelope(geom)) + ((ST_ymax(ST_envelope(geom)) - ST_ymin(ST_envelope(geom)))/2))),4326)
;



--25 ----------------------------------------------------------------------------
-- https://postgis.net/docs/ST_SimplifyPolygonHull.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_SimplifyPolygonHull vertex_fraction 0.6',

'SELECT 
  ST_SimplifyPolygonHull(geom, 0.6)
  FROM message;'
,
ST_SimplifyPolygonHull(geom, 0.6)
FROM message;

--26 ---------------------------------------
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_SimplifyPolygonHull vertex_fraction 0.2',

'SELECT 
  ST_SimplifyPolygonHull(geom, 0.2)
  FROM message;'
,
ST_SimplifyPolygonHull(geom, 0.2)
FROM message;


--27 ----------------------------------------------------------------------------
-- https://postgis.net/docs/ST_MaximumInscribedCircle.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_MaximumInscribedCircle',

'SELECT ST_Collect(geom) FROM (
SELECT ST_buffer((x).center,(x).radius) as geom FROM 
(
  SELECT ST_MaximumInscribedCircle(geom) as x
  FROM message
) as foo
union
  SELECT geom 
  FROM message
) as foo2;'
,
ST_CollectionExtract(ST_Collect(geom),3) FROM (
SELECT ST_buffer((x).center,(x).radius) as geom FROM 
(
  Select
  ST_MaximumInscribedCircle(geom) as x
  FROM message
) as foo
union
  SELECT geom 
  FROM message
) as foo2;

--28 ----------------------------------------------------------------------------
-- https://postgis.net/docs/ST_TriangulatePolygon.html
INSERT INTO letters (name,statement,geom) 
SELECT 'ST_TriangulatePolygon',

'SELECT 
  ST_CollectionExtract(
    ST_TriangulatePolygon(geom)
  ,3)
  FROM message;'
,
ST_CollectionExtract(ST_TriangulatePolygon(geom),3)
FROM message;


Update letters set showdate = gid + (date('2026-03-26')- xid) FROM (SELECT max(gid) as xid FROM letters) as foo;


SELECT * FROM letters order by gid ; --desc limit 1;
