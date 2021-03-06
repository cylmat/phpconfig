<?php

namespace App;

class Sample
{
    /**
     * @codeCoverageIgnore
     */
    public function __construct()
    {
        // @codeCoverageIgnoreStart
        echo '';
        // @codeCoverageIgnoreEnd

        /*if (file_exists('bin/kint.phar')) {
            require 'bin/kint.phar';
            d('$my_var'); //debug
            +d('$my_var'); //debug all
        }*/
    }

    public function sample(int $sample): int
    {
        ++$sample;
        echo ''; // @codeCoverageIgnore

        return $sample;
    }

    public function sampleText(string $sample): string
    {
        return 'it is ' . $sample;
    }

    // Used for mocking tests.
    public function sampleObject(object $object, string $param1 = ''): string
    {
        if (method_exists($object, 'my_method') && '' !== $param1) {
            return $object->my_method($param1);
        }

        return get_class($object);
    }
}
