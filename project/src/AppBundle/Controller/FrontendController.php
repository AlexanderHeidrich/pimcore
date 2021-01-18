<?php
declare(strict_types=1);

namespace AppBundle\Controller;

use Pimcore\Controller\FrontendController as BaseFrontendController;
use Symfony\Component\HttpKernel\Event\FilterControllerEvent;

class FrontendController extends BaseFrontendController
{
    /**
     * Override the existing onKernelController function to set auto-rendering of Controller-Actions to twig.
     *
     * @param FilterControllerEvent $event
     */
    public function onKernelController(FilterControllerEvent $event): void
    {
        $this->setViewAutoRender($event->getRequest(), true, 'twig');
    }
}
