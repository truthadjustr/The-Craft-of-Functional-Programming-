--The Craft of Functional Programming 
--Ch. 14 Introducing Algebraic Types 

import Data.Time 

--14.1

data Temp   = Cold | Hot 
	deriving (Eq,Ord,Enum,Show,Read)
data Season = Spring | Summer | Autumn | Winter 
	deriving (Eq,Ord,Enum,Show,Read)

weather :: Season -> Temp
--weather Summer = Hot
--weather _      = Cold

weather s 
	|s==Summer = Hotgvi
	|otherwise = Cold

--14.2

data Month = January | February | March | April | May | June | July |  August | September | October | November | December
	deriving (Eq,Ord,Enum,Show,Read)

monthToSeason :: Month -> Season
monthToSeason m 
	|filter (==m) [January .. March] /= [] = Winter
	|filter (==m) [April .. June] /= [] = Spring
	|filter (==m) [July .. September] /= [] = Summer
	|otherwise = Autumn

--14.3

weatherNZ :: Season -> Temp
weatherNZ Summer = Cold
weatherNZ _ = Hot

weatherBrazil :: Season -> Temp
weatherBrazil Summer = Cold
weatherBrazil Autumn = Cold
weatherBrazil _ = Hot

--14.4

data Shape  = Circle Float | Rectangle Float Float | Triangle Float Float Float
	deriving (Ord,Show,Read)

perimeter :: Shape -> Float 
perimeter (Circle r) = 2*pi*r
perimeter (Rectangle h w) = 2*h*w
perimeter (Triangle a b c)= a+b+c

--14.5

isRound :: Shape -> Bool
isRound (Circle _)      = True
isRound (Rectangle _ _) = False
isRound (Triangle _ _ _) = False

area :: Shape -> Float
area (Circle r)      = pi*r*r
area (Rectangle h w) = h*w
area (Triangle a b c) = 0.25*sqrt((a+b-c)*(a-b+c)*(-a+b+c)*(a+b+c))

--14.6

isRegular :: Shape -> Bool 
isRegular (Circle _) = True
isRegular (Rectangle h w)
	|h==w = True
	|otherwise = False
isRegular (Triangle a b c)
	|a==b && b==c && c==a = True
	|otherwise = False

--14.7

--The dervived ordering is left to right lowest to greatest. 
--The floats of the same shape are order lexiographially. 
--Documentation was found here http://www.haskell.org/onlinereport/derived.html

--14.8

--My pattern matching doesn't work in trying to define == over Shapes in a new way 

--Could use a permutations function instead for triangle

instance Eq Shape where
  (Circle a) == (Circle b) = a==b || (a<0 && b<0)
  (Rectangle h w) == (Rectangle h' w') = ((h==h' && w==w') || (h==w' && w==h'))
  (Triangle a b c) == (Triangle d e f) = (([a, b, c] == [d, e, f]) || ([a, b, c] == [e, d, f]) || ([a, b, c] == [f, e, d]))
  _ == _ = False 
   
--14.9

type CenterPoint = (Float, Float)

type Radius = Float 

type Height = Float 

type Width = Float 

data NewShape  = CircleN Radius CenterPoint | RectangleN Height Width CenterPoint 
	deriving (Eq, Ord, Show, Read)

--14.10

exC1 :: NewShape
exC1 = CircleN 5 (0,0) 
exC2 :: NewShape 
exC2 = CircleN 3 (1,1) 
exC3 :: NewShape 
exC3 = CircleN 1 (3,5)
exR1 :: NewShape 
exR1 = RectangleN 5 5 (0,0)
exR2 :: NewShape 
exR2 = RectangleN 2 3 (0,4)
exR3 :: NewShape 
exR3 = RectangleN 1 7 (4,5)

move :: CenterPoint -> NewShape -> NewShape
move (x', y') (CircleN r (x, y))= CircleN r (x', y') 
move (x', y') (RectangleN h w (x, y))= RectangleN h w (x', y') 

--14.11

centerToCenterDistance :: CenterPoint -> CenterPoint -> Float
centerToCenterDistance (x1, y1) (x2, y2) = sqrt (((x1-x2)^2)+((y1-y2)^2)) 

xCrd = fst
yCrd = snd

xInRange :: Width -> CenterPoint -> Width -> CenterPoint -> Bool 
xInRange w1 c1 w2 c2 = (lowBound2 < lowBound1 && lowBound1 < highBound2)|| (lowBound2 < highBound1 && highBound1 < highBound2)
	where 
	lowBound1 = w1 - xCrd(c1)
	highBound1 = w1 + xCrd(c1)
	lowBound2 = w2 - xCrd(c2)
	highBound2 = w2 + xCrd(c2) 
	
yInRange :: Height -> CenterPoint -> Height -> CenterPoint -> Bool 
yInRange h1 c1 h2 c2 = (lowBound2 < lowBound1 && lowBound1 < highBound2)|| (lowBound2 < highBound1 && highBound1 < highBound2)
	where 
	lowBound1 = h1 - yCrd(c1)
	highBound1 = h1 + yCrd(c1)
	lowBound2 = h2 - yCrd(c2)
	highBound2 = h2 + yCrd(c2) 
	
overlap :: NewShape -> NewShape -> Bool 
overlap (CircleN r1 c1) (CircleN r2 c2) = (centerToCenterDistance c1 c2) - r1 -r2 <=0 
overlap (RectangleN h1 w1 c1) (RectangleN h2 w2 c2) = (xInRange w1 c1 w2 c2) && (yInRange h1 c1 h2 c2)

--overlap (CircleN r c1) (RectangleN h w c2) 
--	|(centerToCenterDistance c1 c2) - r - w <=0 = True
--	|otherwise = False 

--I haven't figured out a clever way to do this with a rectangle and a circle. 
--I also just got rid of triangles. 

--14.12

data House = Home String | Place Int 
	deriving (Eq, Ord)

instance Show House where
	show (Home st) = st
	show (Place int) = show int

type City = String

type State = String 

type Zipcode = String

type Address = (House, City, State, Zipcode) 

exDress :: Address 
exDress = ((Home "Home"), "Boston", "MA", "02120")

showAddress :: Address -> String
showAddress (h, c, s, z) = show h ++ "\n" ++ c ++", " ++ s ++", "++ show z

--14.13

type Name = String 
type Book = String

data LibraryEntry = Entry Name Book 
	deriving (Eq, Ord, Show, Read)  

type LibraryLoans = [LibraryEntry]

exBib :: LibraryLoans
exBib = [Entry "Alice" "Tintin", Entry "Anna" "Little Women", Entry "Alice" "Asterix", Entry "Rory" "Tintin"]

entryToBook :: LibraryEntry -> Book 
entryToBook (Entry _ book) = book  

entryToPerson :: LibraryEntry -> Book 
entryToPerson (Entry name _ ) = name  

booksDoesHeHaveOnLoan :: LibraryLoans -> Name -> [Book]
booksDoesHeHaveOnLoan loans name = (map entryToBook . filter ((==name).entryToPerson)) loans  

whoHasTheBook :: LibraryLoans -> Book -> [Name]
whoHasTheBook loans book = (map entryToPerson . filter ((==book).entryToBook)) loans 

isBorrowed :: LibraryLoans -> Book -> Bool 
isBorrowed loans book = whoHasTheBook loans book /= []

numBorrowed :: LibraryLoans -> Book -> Int 
numBorrowed loans book = length (whoHasTheBook loans book) 

returnLoan :: LibraryLoans -> LibraryEntry -> LibraryLoans
returnLoan loans entry = filter (/=entry) loans

--14.14

type CD = String
type Video = String 

type DueDate = Day

data NewLibEntry = BookLoan Name Book DueDate | CDLoan Name CD DueDate | VidLoan Name Video DueDate  
	deriving (Eq, Ord, Show, Read)  

type NewLibLoans = [NewLibEntry]

exNewBib :: NewLibLoans
exNewBib = [BookLoan "Alice" "Tintin" (fromGregorian 1999 10 12), BookLoan "Anna" "Little Women" (fromGregorian 1888 09 10), CDLoan "Alice" "Asterix" (fromGregorian 2010 10 12), VidLoan "Rory" "Tintin" (fromGregorian 2000 10 12)]

entryToItem :: NewLibEntry -> String  
entryToItem (BookLoan _ item _ ) = item
entryToItem (CDLoan _ item _ ) = item
entryToItem (VidLoan _ item _ ) = item 

entryToName :: NewLibEntry -> Name
entryToName (BookLoan name _ _ ) = name
entryToName (CDLoan name _ _ ) = name 
entryToName (VidLoan name _ _ ) = name 

entryToEntry :: NewLibEntry -> String 
entryToEntry (BookLoan _ _ _ ) = "BookLoan"
entryToEntry (CDLoan _ _ _ ) = "CDLoan"
entryToEntry (VidLoan _ _ _ ) = "VidLoan"

entryToDueDate :: NewLibEntry -> DueDate 
entryToDueDate (BookLoan _ _ dd ) = dd
entryToDueDate (CDLoan _ _ dd ) = dd 
entryToDueDate (VidLoan _ _ dd ) = dd 

allBooksHeHasOnLoan :: NewLibLoans -> Name -> [Book]
allBooksHeHasOnLoan loan name = (map entryToItem . filter ((==name).entryToName). filter ((=="BookLoan").entryToEntry)) loan  

allCDsHeHasOnLoan :: NewLibLoans -> Name -> [CD]
allCDsHeHasOnLoan loan name = (map entryToItem . filter ((==name).entryToName). filter ((=="CDLoan").entryToEntry)) loan  

allVidsHeHasOnLoan :: NewLibLoans -> Name -> [Video]
allVidsHeHasOnLoan loan name = (map entryToItem . filter ((==name).entryToName). filter ((=="VidLoan").entryToEntry)) loan  

allHeHasOnLoanOneList :: NewLibLoans -> Name -> [String]
allHeHasOnLoanOneList loan name = (map entryToItem . filter ((==name).entryToName)) loan  

allHeHasOnLoan :: NewLibLoans -> Name -> ([Book],[CD],[Video]) 
allHeHasOnLoan loans name = (allBooksHeHasOnLoan loans name, allCDsHeHasOnLoan loans name, allVidsHeHasOnLoan loans name)

allDueBackBeforeThen :: NewLibLoans -> DueDate -> [String]
allDueBackBeforeThen loans date = (map entryToItem . filter((<date).entryToDueDate)) loans

personHasDueBeforeThen :: NewLibLoans -> Name -> DueDate -> [String]
personHasDueBeforeThen loans name date = (map entryToItem . filter((<date).entryToDueDate). filter ((==name).entryToName)) loans

makeDueDate :: NewLibEntry -> NewLibEntry
makeDueDate (BookLoan n bk dd ) = (BookLoan n bk (addGregorianMonthsRollOver 1 dd))
makeDueDate (CDLoan n cd dd ) = (CDLoan n cd (addDays 7 dd))
makeDueDate (VidLoan n vid dd ) = (VidLoan n vid (addDays 3 dd))

today :: Day
today = fromGregorian 2010 10 20

type LoanType = String 
type Item = String

addLoan :: NewLibLoans -> Name -> LoanType -> Item -> NewLibLoans 
addLoan existingLoans name typeOfLoan title
	|(typeOfLoan == "Book") = (makeDueDate(BookLoan name title today)):existingLoans 
	|(typeOfLoan == "CD") = (makeDueDate(CDLoan name title today)):existingLoans 
	|(typeOfLoan == "Video") = (makeDueDate(VidLoan name title today)):existingLoans 

--14.15

{-data Expr = Lit Int | Add Expr Expr | Sub Expr Expr

eval :: Expr -> Int

eval (Lit n)     = n
eval (Add e1 e2) = (eval e1) + (eval e2)
eval (Sub e1 e2) = (eval e1) - (eval e2)

instance Show Expr where
	show (Lit n) = show n
	show (Add e1 e2) = "(" ++ show e1 ++ "+" ++ show e2 ++ ")"
	show (Sub e1 e2) = "(" ++ show e1 ++ "-" ++ show e2 ++ ")"-}

{-Show Calculations 
eval (Lit 67)
67

eval (Add (Sub (Lit 3) (Lit 1))(Lit 3))
eval (Add (eval (Lit 3) - eval (Lit 1))(Lit 3))
eval (Add (3 - 1))(Lit 3))
eval (Add (2)(3))
eval (2)+ eval(3)
2+3
5

show (Add (Lit 67) (Lit (-34)))
"(" ++ show (Lit 67) ++ "+" ++ show (Lit(-34)) ++ ")" 
"(" ++ 67 ++ "+" ++ -34 ++ ")" 
"(67+-34)"-}

--14.16

{-size :: Expr -> Int 
size (Lit _ ) = 0
size (Add e1 e2) = 1 + size e1 + size e2
size (Sub e1 e2) = 1 + size e1 + size e2-}

--14.17

{-
data Expr = Lit Int | Add Expr Expr | Sub Expr Expr | Mult Expr Expr | Div Expr Expr

eval :: Expr -> Int
eval (Lit n)     = n
eval (Add e1 e2) = (eval e1) + (eval e2)
eval (Sub e1 e2) = (eval e1) - (eval e2)
eval (Mult e1 e2) = (eval e1) * (eval e2)
eval (Div e1 e2) = (eval e1) `div` (eval e2) 
--Will return error if (eval e2 ==0), need maybe case, will see next section 

instance Show Expr where
	show (Lit n) = show n
	show (Add e1 e2) = "(" ++ show e1 ++ "+" ++ show e2 ++ ")"
	show (Sub e1 e2) = "(" ++ show e1 ++ "-" ++ show e2 ++ ")"
	show (Mult e1 e2) = "(" ++ show e1 ++ "*" ++ show e2 ++ ")"
	show (Div e1 e2) = "(" ++ show e1 ++ "/" ++ show e2 ++ ")"
	
size :: Expr -> Int 
size (Lit _ ) = 0
size (Add e1 e2) = 1 + size e1 + size e2
size (Sub e1 e2) = 1 + size e1 + size e2
size (Mult e1 e2) = 1 + size e1 + size e2
size (Div e1 e2) = 1 + size e1 + size e2
-}

--14.18

{-data Ops = Add | Sub | Mul | Div | Mod

instance Show Ops where
	show Add = " + "
	show Sub = " - "
	show Mul = " * "
	show Div = " div "
	show Mod = " mod "

data ModExpr = Lit Int | Op Ops ModExpr ModExpr

instance Show ModExpr where
	show (Lit n) = show n
	show (Op op e1 e2) = "(" ++ show e1 ++ (show op) ++ show e2 ++ ")"

evalM :: ModExpr -> Int
evalM (Lit n)     = n
evalM (Op Add e1 e2) = (evalM e1) + (evalM e2)
evalM (Op Sub e1 e2) = (evalM e1) - (evalM e2)
evalM (Op Mul e1 e2) = (evalM e1) * (evalM e2)
evalM (Op Div e1 e2) = (evalM e1) `div` (evalM e2) 
evalM (Op Mod e1 e2) = (evalM e1) `mod` (evalM e2) 

sizeM :: ModExpr -> Int 
sizeM (Lit _ ) = 0
sizeM (Op _ e1 e2) = 1 + sizeM e1 + sizeM e2-}

--14.19 

data NTree = NilT | NodeT Int NTree NTree

instance Show NTree where
	show (NilT) = "NilT"
	show (NodeT int t1 t2 ) = "[" ++ (show int) ++" "++ (show t1) ++ " " ++ (show t2) ++ "]" 

sumTree :: NTree -> Int
sumTree NilT           = 0
sumTree (NodeT n t1 t2) = n + sumTree t1 + sumTree t2

depth :: NTree -> Int
depth NilT             = 0
depth (NodeT n t1 t2)   = 1 + max (depth t1) (depth t2)

occurs :: NTree -> Int -> Int
occurs NilT p = 0
occurs (NodeT n t1 t2) p
  | n==p        = 1 + occurs t1 p + occurs t2 p
  | otherwise   =     occurs t1 p + occurs t2 p

{-Show Calcultions
sumTree (NodeT 3 (NodeT 4 NilT NilT) NilT)
3 + sumTree(NodeT 4 NilT NilT) + sumTree NilT
3 + 4 + 0
7

depth (Node 3 (NodeT 4 NilT NilT) NilT)
1 + max (depth (NodeT 4 NilT NilT))(depth NilT)
1 + max (1 + max (depth NilT) (depth NilT)) 
1 + max (1 + max 0 0) 0
1 + max (1 + 0) 0
1 + max 1 0 
1 + 1
2 -}

--14.20

data Expr' = Lit' Int | Expr' :+: Expr' | Expr' :-: Expr'

eval' :: Expr' -> Int 
eval' (Lit' n)     = n
eval' (e1 :+: e2) = (eval' e1) + (eval' e2)
eval' (e1 :-: e2) = (eval' e1) - (eval' e2)

instance Show Expr' where
	show (Lit' n) = show n
	show (e1 :+: e2) = "(" ++ show e1 ++ "+" ++ show e2 ++ ")"
	show (e1 :-: e2) = "(" ++ show e1 ++ "-" ++ show e2 ++ ")"
	
size' :: Expr' -> Int 
size' (Lit' _ ) = 0
size' (e1 :+: e2) = 1 + size' e1 + size' e2
size' (e1 :-: e2) = 1 + size' e1 + size' e2

--14.21

--Need Maybe

rightTree :: NTree -> NTree
rightTree (NodeT _ _ tr ) = tr

leftTrees :: NTree -> NTree 
leftTrees (NodeT _ tl _ ) = tl
 
--14.22

allInt :: NTree -> [Int]
allInt NilT = []
allInt (NodeT int t1 t2) = [int] ++ (allInt t1) ++ (allInt t2)

isTreeElem :: Int -> NTree -> Bool 
isTreeElem n t = (filter (==n) (allInt t)) /=[]

--14.23

--I really need the Maybe type here

maxTree :: NTree -> Int 
maxTree t = foldr1 max (allInt t)

minTree :: NTree -> Int
minTree t = foldr1 min (allInt t)

--14.24

reflect :: NTree -> NTree
reflect NilT = NilT 
reflect (NodeT int t1 t2) = (NodeT int t2 t1) 

--reflect.reflect brings back the orginal tree

--14.25

collapse :: NTree -> [Int] 
collapse NilT = []
collapse (NodeT int tl tr) = (collapse tl) ++ [int] ++ (collapse tr) 

qSort :: Ord a => [a] -> [a]
qSort []     = []
qSort (x:xs) = qSort [z|z<-xs,z<=x] ++ [x] ++ qSort [z|z<-xs,z>x]

sort :: NTree -> [Int]
sort t = qSort (collapse t)

--14.26

data Person = Adult Name Address Biog | Child Name
data Biog   = Parent String [Person] | NonParent String

showPerson (Adult nm ad bio) = show nm ++ showAddress ad ++ showBiog bio
showPerson (Child nm) = show nm

showBiog (Parent st perList) = st ++ concat (map showPerson perList) 
showBiog (NonParent st) = st

 --14.27
 
data Expr = Lit Int | Op Ops Expr Expr | If BExp Expr Expr

data Ops = Add | Sub | Mul | Div | Mod

data BExp = BoolLit Bool | And BExp BExp | Not BExp | Equal Expr Expr | Greater Expr Expr

instance Show Ops where
	show Add = " + "
	show Sub = " - "
	show Mul = " * "
	show Div = " div "
	show Mod = " mod "

instance Show Expr where
	show (Lit n) = show n
	show (Op op e1 e2) = "(" ++ show e1 ++ (show op) ++ show e2 ++ ")"
	show (If bexp e1 e2) ="( If " ++ show bexp ++ show e1 ++ show e2 ++ ")"

instance Show BExp where
	show (BoolLit b) =  show b  
	show (And b1 b2) = "(" ++ show b1 ++ " && " ++ show b2 ++ ")"
	show (Not b) = "(" ++ " not " ++ show b ++ ")"
	show (Equal e1 e2) = "(" ++ (show e1) ++ " == " ++ (show e2) ++ ")"
	show (Greater e1 e2) = "(" ++ (show e1) ++ " > " ++ (show e2) ++ ")"
	
eval :: Expr -> Int
eval (Lit n)     = n
eval (Op Add e1 e2) = (eval e1) + (eval e2)
eval (Op Sub e1 e2) = (eval e1) - (eval e2)
eval (Op Mul e1 e2) = (eval e1) * (eval e2)
eval (Op Div e1 e2) = (eval e1) `div` (eval e2) 
eval (Op Mod e1 e2) = (eval e1) `mod` (eval e2) 
eval (If bexp e1 e2) 
	|bEval bexp = eval e1
	|otherwise = eval e2 

bEval :: BExp -> Bool 
bEval (And b1 b2) = bEval b1 && bEval b2
bEval (Not b) = not (bEval b)
bEval (Equal e1 e2) = eval e1 == eval e2
bEval (Greater e1 e2) = eval e1 > eval e2

--14.28

data Tree a = Nil | Node a (Tree a) (Tree a)
	deriving (Eq,Ord,Show,Read)

occursT :: (Eq a) => Tree a -> a -> Int
occursT Nil p = 0
occursT (Node n t1 t2) p
  | n==p        = 1 + occursT t1 p + occursT t2 p
  | otherwise   =     occursT t1 p + occursT t2 p

depthT :: Tree a -> Int
depthT Nil = 0
depthT (Node n t1 t2) = 1 + max (depthT t1) (depthT t2)

collapseT :: Tree a -> [a]
collapseT Nil = []
collapseT (Node x t1 t2) = collapseT t1 ++ [x] ++ collapseT t2
 
lTree :: Tree a -> Tree a 
lTree (Node n t1 t2) = t1

rTree :: Tree a -> Tree a 
rTree (Node n t1 t2) = t2

sortT :: (Ord a) =>  Tree a -> [a]
sortT t = qSort (collapseT t)

reflectT :: Tree a -> Tree a
reflectT Nil = Nil
reflectT (Node a t1 t2) = (Node a t2 t1) 

data PolyExpr a = PolyLit a | PolyAdd (PolyExpr a) (PolyExpr a) | PolySub (PolyExpr a) (PolyExpr a)

peval :: (Num a) => PolyExpr a -> a
peval (PolyLit n)     = n
peval (PolyAdd e1 e2) = (peval e1) + (peval e2)
peval (PolySub e1 e2) = (peval e1) - (peval e2)

instance (Show a)=> Show (PolyExpr a) where
	show (PolyLit n) = show n
	show (PolyAdd e1 e2) = "(" ++ show e1 ++ "+" ++ show e2 ++ ")"
	show (PolySub e1 e2) = "(" ++ show e1 ++ "-" ++ show e2 ++ ")"
	
sizep :: PolyExpr a -> Int 
sizep (PolyLit _ ) = 0
sizep (PolyAdd e1 e2) = 1 + sizep e1 + sizep e2
sizep (PolySub e1 e2) = 1 + sizep e1 + sizep e2

--14.29

twist :: Either a b -> Either b a
twist (Left a) = (Right a)
twist (Right b) = (Left b)

--14.30

--either :: (a -> c) -> (b -> c) -> Either a b -> c
--either f g (Left x)  = f x
--either f g (Right y) = g y

--applyLeft :: (a -> c) -> Either a b -> c
--applyLeft f (Left x)  = f x
--applyLeft f (Right _) = error "applyLeft applied to Right"

applyLeft :: (a -> c) -> Either a b -> c
applyLeft f e = either f (\a -> error "applyLeft applied to Right") e 

--14.31

typeChanger :: (a -> b) -> a -> Either b c
--typeChanger f = \x -> (Left (f x))  
typeChanger f x = (Left (f x))

typeChangerR :: (a -> b) -> a -> Either c b
typeChangerR f = \x -> (Right (f x))  

--14.32

joiner :: (a -> c) -> (b -> d) -> Either a b -> Either c d
--joiner f g (Left x) = Left (f x) 
--joiner f g (Right y) = Right(g y)
--joiner f g e = either (\x -> Left (f x)) (\x -> Right (g x)) e
joiner f g = either (Left .f) (Right .g)
--joiner f g = either (typeChanger f) (typeChangerR g)

--14.33

data GTree a = Leaf a | Gnode [GTree a]

leafCount :: (GTree a) -> Int 
leafCount (Leaf a) = 1
leafCount (Gnode xs) = sum (map leafCount xs) 

gDepth :: (GTree a) -> Int 
gDepth (Leaf _ ) = 0
gDepth (Gnode []) = 1
gDepth (Gnode xs) = 1 + (foldr1 max (map gDepth xs)) 

gSum :: (GTree Int) -> Int 
gSum (Leaf x) = x
gSum (Gnode xs) = sum (map gSum xs) 

isElemG :: (Eq a) => a -> (GTree a) -> Bool 
isElemG e (Leaf b) = e==b 
isElemG e (Gnode xs) = (filter (==True) (map (isElemG e) xs)) /= []

gMap :: (a -> b) -> (GTree a) -> (GTree b)
gMap f (Leaf x) = (Leaf (f x))
gMap f (Gnode xs) = (Gnode (map (gMap f) xs))

flatten :: (GTree a) -> [a]
flatten (Leaf x) = [x]
flatten (Gnode xs) = foldr (++) [] (map flatten xs)

--14.34

--An empty GTree is GNode[]

--14.35

process :: [Int] -> Int -> Int -> Int
process xs m n = maybe 0 id (bangbangerr xs m n)
-- |(length xs) > m || (length xs > n) = 0
-- |otherwise =  xs!!m + xs!!n 
  
bangbangerr :: [Int] -> Int -> Int  -> Maybe Int
bangbangerr xs n m
	| (length xs) > n && (length xs) > m = Just ((xs!!n) + (xs!!m)) 
	| otherwise = Nothing
	
--14.37

squashMaybe :: Maybe (Maybe a) -> Maybe a 
squashMaybe Nothing = Nothing 
squashMaybe (Just (Nothing)) = (Nothing)	
squashMaybe (Just (Just x)) = (Just x)

--14.38

mapMaybe :: (a -> b) -> Maybe a -> Maybe b
mapMaybe g Nothing  = Nothing
mapMaybe g (Just x) = Just (g x)

--(.) :: (b -> c) -> (a -> b) -> (a -> c)

{-ex
f:: a -> Just b 
g:: b -> Just c 
goal : a -> Just c

f:: a -> Just b 
g:: b -> Nothing 
goal : a -> Nothing

f :: a -> Nothing 
g :: b -> Just c
goal :: a -> Just c 

f:: a -> Nothing  
g:: b -> Nothing
goal :: a -> Nothing -}

composeMaybe :: (a -> Maybe b) -> (b -> Maybe c) -> (a -> Maybe c)
composeMaybe f g = \x -> squashMaybe (mapMaybe g (f x))

--14.39

data Err a = OK a | Error String

mapErr :: (a -> b) -> Err a -> Err b
mapErr g (Error str)  = (Error str)
mapErr g (OK x) = OK (g x)

maybeE :: b -> (a -> b) -> (Err a) -> b
maybeE n f (Error  _ )  = n
maybeE n f (OK x) = f x

squashErr :: Err (Err a) -> Err a 
squashErr (Error st) = (Error st) 
squashErr (OK (Error st)) = (Error st)	
squashErr (OK (OK x)) = (OK x)

composeErr :: (a -> Err b) -> (b -> Err c) -> (a -> Err c)
composeErr f g = \x -> squashErr (mapErr g (f x))

--14.44

data Edit = Change Char |
            Copy |
            Delete |
            Insert Char |
            Kill  |
            Switch
            deriving (Eq,Show)



transform :: String -> String -> [Edit]
transform [] [] = []
transform xs [] = [Kill]
transform [] ys = map Insert ys
transform ex@(x:x':xs) ey@(y:y':ys)
  | (x==y') && (x'==y) = Switch :transform xs ys
transform (x:xs) (y:ys)     
  | x==y        = Copy : transform xs ys                    
  | otherwise   = best [ Delete   : transform xs (y:ys) ,
                         Insert y : transform (x:xs) ys ,
                         Change y : transform xs ys ]

best :: [[Edit]] -> [Edit]
best [x]   = x
best (x:xs) 
  | cost x <= cost b    = x
  | otherwise           = b
      where 
      b = best xs

cost :: [Edit] -> Int
cost = length . filter (/=Copy)

edit :: [Edit] -> String -> String
edit [] str = str
edit [Kill] _ = ""
edit ((Change c):es) (s:ss) = (c:(edit es ss))
edit (Copy:es) (s:ss) = (s: (edit es ss))
edit (Delete:es) (s:ss) = edit es ss
edit ((Insert c): es) str = (c: (edit es str))
edit (Switch:es) (s:s':ss) = (s':s: (edit es ss))

showTransforms :: [Edit] -> String -> [String]
showTransforms [] "" = []
showTransforms [] ss = [ss]
showTransforms [Kill] ss = [ss]
showTransforms ((Change c):es) (s:ss) = (c:ss) : (c ++ showTransforms es (c:ss)) 

--editting program is not fully complete may return to in the future
	 
--14.47

--I'm not sure how to declare these instances?
--Take advantage of multiple inhertance (Section 12.3)

instance (Movaeble b, Named c) => NamedMoveable (b , c) 

instance Moveable b => Moveable (b, c) where
	move v = fst (move v)
	reflectX = fst reflectX
	reflectY = fst reflectY

instance Named c => Named (b, c) where
	lookname (obj, nm) = nm
	givename nm (obj, _) = (obj, nm)

--14.49

--This question asks you to generalize the above concept, but not sure if the above concept is correctly implemented

--14.50

--Same as 14.49 

--14.51

--Defining a class MoveablePlus over the class moveable is the better option bc it allows you to keep the functions in modular packages that can be used as needed. Also that way if the functions aren't applicable to a cetrain moveable object (like a point) they need not be defined over that data type.  

{-
data : to make Construtors 
 nullary, binary, or more, can be polymorphic
class : defines a package of functions that can operate over (a type?)/ many types 
type : declaration allows you to give names to things (type Money = Float), allows you to speficy type (type 4 = Float) ?
instance : the particular functions of a class defined for a type (I don't see a clear distinction between instance and class declarations)
derived classes (=>) : classes that depend on other classes, also seen as inherhiting there properties 
context : the classes the other that a derived class depends on 		
Does this all carryoutside of Haskell too?
-} 


data Vector = Vec Float Float

class Movable a where
  move      :: Vector -> a -> a
  reflectX  :: a -> a
  reflectY  :: a -> a
  rotate180 :: a -> a
  rotate180 = reflectX . reflectY

data Point = Point Float Float 
             deriving Show

instance Movable Point where
  move (Vec v1 v2) (Point c1 c2) = Point (c1+v1) (c2+v2)
  reflectX (Point c1 c2)  = Point c1 (-c2)
  reflectY (Point c1 c2)  = Point (-c1) c2
  rotate180 (Point c1 c2) = Point (-c1) (-c2)

data Figure = Line Point Point |
              Circle Point Float 
              deriving Show

instance Movable Figure where
  move v (Line p1 p2) = Line (move v p1) (move v p2)
  move v (Circle p r) = Circle (move v p) r

  reflectX (Line p1 p2) = Line (reflectX p1) (reflectX p2)
  reflectX (Circle p r) = Circle (reflectX p) r

  reflectY (Line p1 p2) = Line (reflectY p1) (reflectY p2)
  reflectY (Circle p r) = Circle (reflectY p) r

instance Movable a => Movable [a] where
  move v   = map (move v)
  reflectX = map reflectX
  reflectY = map reflectY

class Movable a => MoveablePlus a where
 scale :: a -> Float -> a  
 rotateDegrees :: a -> Float -> a

instance MoveablePlus Figure where
	scale (Line p1 p2) _ = (Line p1 p2)
	scale (Circle p r) scaler = (Circle p (* r p)
	
	rotateDegrees (Line p1 p2) angle = (Line p1 (* p2 angle) 
--need to figure out actual formula for rotating angle 
	rotateDegrees (Circle p1 p2) _ = (Circle p1 p2)	    

--14.51

--Can resue type name:
class Named a where
  lookName :: a -> String
  giveName :: String -> a -> a

data Name a = Pair a String

instance Named (Name a) where
  lookName (Pair obj nm) = nm
  giveName nm (Pair obj _) = (Pair obj nm)

mapName :: (a -> b) -> Name a -> Name b
mapName f (Pair obj nm) = Pair (f obj) nm

--Design Classes to Model a Bank Account

type Money = Float
type Balance = Money
type AccountID = String  
type Account = [AccountEntry]
type AccountEntry = (Balance, Day, Transaction)

data Transaction a = (Deposit Money) | (Withdraw Money) | CheckBalance

--Does is make sense to have a class not defined over polymorphic types? Or is that the whole point of a a class?
class (Named a) => NamedAccount  where
	deposit, withdraw :: BankDB -> AccountID -> Money -> NamedAccount
	balance :: BankDB -> AccountID -> AccountEntry
	priorBalance :: BankDB -> AccountID -> Day -> Account  
	fullAccount :: BankDB -> AccountID -> Account
	newAccount :: BankDB -> AccountID -> BankDB 

--How would I define the BankDB? Would it just be a type? Even though it is derived from Named?
type BankDB = [NamedAccount]
--Obviously regardless of this question the bankdatabase would actual need to be a database not just a list of tuples, and IO would need to be accounted for 

--14.52

data Temp   = Cold | Hot
data Season = Spring | Summer | Autumn | Winter

weather :: Season -> Temp
weather Summer = Hot
weather _      = Cold

instance Eq Temp where
  Cold == Cold  = True
  Hot  == Hot   = True
  _    == _     = False

makeHot True = Hot
makeHot False = Cold
isSummer = (==Summer)

newWeather = makeHot . isSummer

--Proof By Cases:
newWeather x = weather x

if x = Spring
weather Spring = Cold
neweather Spring = makeHot False = Cold
Cold = Cold
(Same x = Autumn, Winter

if x = Summer 
weather Summer = Hot
newWeather Summer = makeHot True = Hot

--14.53

data Shape = Circle Float |
             Rectangle Float Float

area :: Shape -> Float
area (Circle r)      = pi*r*r
area (Rectangle h w) = h*w

Proof by Cases:
area x >= 0

if x = (Circle r) and r > 0
area = pi*r*r >= 0 

if x = (Rectangle h w) and h,w >=0 
area = h*w >=0

--So there is not actually anything in the program to stop the user from using negtive r,h,w values, though it makes no physical sense. If h and w have the oppossite signs area could have a negtive value. 

--14.54
data NTree = NilT | Node Int NTree NTree

depth Nilt = 0
depth (Node _ t1 t2) = 1 + max (depth t1) (depth t2) 

size NilT = 0
size (Node x t1 t2) = 1 + size t1 + size t2

Proof:
size tr < 2^(depth tr) (hypo)

Prove P(nil):
if tr = NilT 
size NilT = 0 
depth NilT = 0
0 < 2^0
0 < 1

Assumming  P(t1) and P(t2), prove P(Node x t1 t2):  
size t1 < 2^(depth t1) 
size t2 < 2^(depth t2) 

size (Node x t1 t2) < 2^(depth (Node x t1 t2)
1 + size t1 + size t2 < 2^(1 + max (depth t1) (depth t2))
ln(1 + size t1 + size t2) < (1 + max (depth t1) (depth t2))ln(2)
ln((1/2) +(1/2)*(size t1) + (1/2)*(size t2))
	 < (1 + max (depth t1) (depth t2)
ln((1/2) + (1/2)*(2^(depth t1) + (1/2)*(2^(depth t2))
	< (1 + max (depth t1) (depth t2))
ln((1/2) + 1 + 1) <
	< (1 + max (depth t1) (depth t2))
ln(2.5) - 1 <  max (depth t1) (depth t2)
a negitive number < a postive number 

--14.55

occurs NilT p = 0
occurs (NodeT n t1 t2) p
| n==p        = 1 + occurs t1 p + occurs t2 p
| otherwise   =     occurs t1 p + occurs t2 p

lenght [] = 0 
lenght x:xs = 1 + lenght xs

filter p xs = [ x  | x <- xs, p x]

collapse NilT = []
collapse (NodeT x t1 t2) = collapse t1 ++ [x] ++ collapse t2

Prove: 
occurs tr x = lenght(filter (==x) (collapse tr))

Base Case:
occurs Nil x = 0 
lenght(filter (==x) (collapse Nil)) = lenght(filter (==x) [])
=length([])=0
0=0

Assume:
occurs t1 x = lenght(filter (==x) (collapse t1))
occurs t2 x = lenght(filter (==x) (collapse t2))

Induction:
if x/=i 
occurs (NodeT i t1 t2) x
	 = lenght (filter (==x) (collapse (Node i t1 t2))  
occurs t1 x + occurs t2 x
	 = lenght (filter (==x) (collapse t1 + [i] + collapse t2))
	 = lenght (filter (==x) collapse t1))
	 + lenght (filter (==x) collaspe t2))

(filter (==x) (collapse t1))

--14.56
Prove:
twist . twist = id

twist . twist (Left a) = twist (Right a) = (Left a)
id (Left a) = (Left a) 
(Left a) = (Left a)

twist . twist (Right a) = twist (Left a) = (Right a)
id (Right a) = (Right a) 
(Right a) = (Right a)

--14.57 

--To prove P(x) for GTree the Leaf case must be proved P(Leaf) and the Node case must be proved where P(Node [x:xs]), the node proof is done the same way any proof by induction over a list is performed. 

data GTree a = Leaf a | Gnode [GTree a]

mapTree f (Leaf a) = (Leaf (f a))
mapTree f (GNode []) = (GNode []) 
mapTree f (GNode (x:xs)) = (GNode ((f x): mapTree f xs)) 
 
map f [] = []
map f (x:xs) = f x : map f xs

collapse (Leaf a) = [a] 
collapse (GNode []) = []
collapse (GNode (x:xs)]) = (collapse x) ++ (collapse xs)

map f (xs++ys) = map f xs ++ map f ys

Prove:
collapse . (mapTree f)  = (map f) . collapse

Base:
collapse . mapTree f (Leaf a) = collapse (Leaf (f a)) = [(f a)]
(map f) . collaspe (Leaf a) = map f [a] = [(f a)]
[(f a)] = [(f a)]

Induction: 
collapse . mapTree f (GNode x:xs) 
	= collapse (GNode (f x: mapTree f xs)) 
 	= collapse (f x) ++ collapse (mapTree f xs)
	= (f x) ++ collapse (mapTree f xs) 

(map f). collapse (GNode [xs]) 
	= (map f) . (collapse x ++ collapse xs)
	= map f (collapse x) ++ map f (collapse xs)
	= (f x) ++ map (collaspe xs) 

