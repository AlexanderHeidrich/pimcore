# Basics

The PSR-12 guidelines should be followed without exceptions: [https://www.php-fig.org/psr/psr-12/](https://www.php-fig.org/psr/psr-12/)

The following example covers many of the rules defined in these guidelines:

```php
<?php
declare(strict_types=1);

namespace Vendor\Package;

use Vendor\Package\{ClassA as A, ClassB, ClassC as C};
use Vendor\Package\SomeNamespace\ClassD as D;
use Vendor\Processor\Processor;

use function Vendor\Package\{functionA, functionB, functionC};

use const Vendor\Package\{ConstantA, ConstantB, ConstantC};
// All namespaces must be imported
use Exception;

class Foo extends Bar implements FooInterface
{
    public function sampleFunction(int $arg1, int $arg2, string $arg3, Processor $processor): array
    {
        if ($arg1 === $arg2) {
            bar();
        } elseif ($arg1 > $arg2) {
            $processor->bar($arg1);
        } else {
            // Try not to use static methods
            // This example is for purposes of syntax demonstration only
            BazClass::bar($arg2, $arg3);
        }

        if ($arg1 > 100) {
            throw new Exception('All namespaces must be imported');
        }
    }

    final public static function bar(): array
    {
        $var1          = 'test';
        $longerVarName = 'test3';
    
        $var2       = 'blue';
        $myVariable = 'red';
        
        $myArray = [
            'test'          => 'a',
            'foo'           => 'b',
            'longerKey'     => 'c',
            'var1'          => $var1,
            'longerVarName' => $var2
        ];

        return array_keys($myArray);
    }
}
```

# Strict types

All PHP files should use:

```php
declare(strict_types=1);
```

# Strings

- Single quotes must be used
- when concatenating strings single quotes and the `.` concatenation parameter should be used
- a whitespace is required before and after concatenation parameter

    `$foo = 'Values should be between ' . $min . ' and ' . $max . ' characters';`

- as an alternative for complex or longer strings `sprintf` may be used

    `throw new Exception('The value %d is not valid. The value must be between %d and %d', $value, $min, $max);`

# Namespaces

- all namespaces must be imported through `use` statements
- in case the Class Name doesn't make sense on its own, an Alias should be used:
    - eg. `\Basilicom\Shop\Service` should be imported as `ShopService`: 
      `use Basilicom\Shop\Service as ShopService`

# Internal function calls

Internal function calls should not be prepended with a backslash:
```php
// BAD
\array_keys($myArray);

// OK
array_keys($myArray);
```

# Array values alignment

Array values must be aligned:

```php
$myArray = [
    'test'      => 'a',
    'foo'       => 'b',
    'longerKey' => 'c'
];
```

Variable blocks must be aligned:
```php
$test      = 'a';
$foo       = 'b';
$longerKey = 'c';
```

# Language

English terms should be used everywhere in the code unless if  describing a complex domain where translating the terms would be too costly, error prone or even impossible (as per DDD):

```php
// BAD
public function ladeBilder() {}
public function gibSteckschaumDimensionen() {}

// GOOD
public function loadImages() {}
public function getSteckschaumDimensions() {}
```

# Trailing commas

- trailing commas must be used in multiline array and function declaration
    ```php
    public function myMethod(
    	string $firstName, 
    	string $lastName,
    ) {
    	// code
    }
    
    $cities = [
    	'Berlin', 
    	'München', 
    	'Köln', 
    	'Bonn', 
    	'Hamburg',
    ];
    ```

- trailing commas must not be used  on single line declaration
   ```php
    public function myMethod(string $firstName, string $lastName) 
    {
    	// code
    }
    
    $cities = ['Berlin', 'München', 'Köln', 'Bonn', 'Hamburg'];
   ```

# If statements

- to improve readability no yoga conditions are allowed
- long or complex conditions should be split into multiple variables that explain the conditions

```php
// BAD
if (($price > 100 && $cart->getProductCount() > 10) || ($price => 50 && $user->isInClub()) {
    ////
}

// GOOD
$entitledForQuantityDiscount = $price > 100 && $cart->getProductCount() > 10;
$entitledForClubDiscount = $price => 50 && $user->isInClub();
if ($entitledForQuantityDiscount && $entitledForClubDiscount) {
    ////
}
```

# DocBlocks

The DocBlocks should provide only the information that can't be provided by the PHP built-in functionality:
```php
// BAD
/*
 * @param int $arg1
 * @param int $arg2
 * @param string $arg3
 * @param Processor $processor
 * @return array
 * @throws Exception
 */
public function sampleFunction(int $arg1, int $arg2, string $arg3, Processor $processor): array
{
}

// GOOD
/*
 * @return array|MyObject[]
*/
public function sampleFunction(int $arg1, int $arg2, string $arg3, Processor $processor): array
{
}
```

# Early returns or guard clauses

Prevent nesting of if clauses and return as soon as possible:
```php
// BAD
public function foo($bar, $baz)
{
    if ($bar > 10) {
        $filename = $baz . $bar . '.txt';
        if (file_exists($filename)) {
            return file_get_contents($baz);
        } else {
            return "";
        }
    } else {
        return "";
    }
    
}

// GOOD
public function foo($bar, $baz)
{
    if ($bar > 10) {
        return "";
    }
    
    $filename = $baz . $bar . '.txt';
    if (!file_exists($filename)) {
        return "";
    }
    
    return file_get_contents($baz);
}
```

# Method name conventions

Expectations behind domain names must be considered based on the type of the object. We are considering the following types:

### Service (Repository)

- **get* (eg. getUserById, getLoggedInUser)**
    - returns a value or throws exception
    - never returns null
    - may do "heavy" operations (DB, filesystem, API call)
    - no side effects
    - if a method does cause side effects, then the name must clearly communicate that
        - eg. getOrCreateFolderByPath
- **find* (eg. findUsersById)**
    - in the name the entity should be pluralized
    - returns always a collection, array or an instance of class that implements Iterable
    - can return an empty array
- **remove* (eg. removeUserById)**
    - void method
    - throws exception when entry not found or could not be deleted
        - should produce two semantically different exceptions
- **create* (eg. createUser)**
    - repositories should use save* instead
    - returns the entity
    - throws exception when entry could not be created or would be duplicated
- **update* (eg. updateUser)**
    - returns the updated entity
    - throws exception when entry not found or could not be updated
        - should produce two semantically different exceptions
- **is** (eg. isConfirmed)
    - returns boolean value
- **are** (eg. areAllUsersConfirmed)
    - returns a boolean value
    - a plural version of the is*** methods

### Entity

- get* (eg. getName)
    - return type defines if a null may be returned
    - no side effects
    - no heavy operations expected

# General guidelines

- our own Exception should never be called just `Exception`, the name must already explain the intent of the exception, eg. `FileNotFoundException`
- no single char variable names
    - allowed exceptions
        - $e for an $exception only in a catch block
          ```php
            // BAD
            $e = new Exception('My exception message');
            
            if ($myCondition) {
            	throw $e;
            }
            
            // OK
            try {
            	$this->myMethodThatThrowsAnException();
            } catch (\Exception $e) {
            	$this->logger->err($e->getMessage();
            }
          ```
        - $i for index in for or foreach
          ```php
            foreach ($address as $i => $addresses) {
            	//
            }
            
            for ($i=0; $i < 20; $i++) {
            	//
            }
          ```

- follow SOLID principles
- always use dependency injection where applicable
- the classes must be testable
    - dependencies can be exchanged, the classes can live isolated from other Frameworks and applications
    - service locator should not be used
